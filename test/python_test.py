#!/usr/bin/env python
# -*- coding: utf-8 -*-

# To install the Python client library:
# pip install -U selenium
import time
import os
from retrying import retry

# Import the Selenium 2 namespace (aka "webdriver")
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

import argparse
parser = argparse.ArgumentParser(description='Perform some basic selenium tests.')
parser.add_argument('browser', choices=['chrome', 'firefox', 'mobile_emulation'], nargs='?', default='chrome',
                    help='in which browser to test')
args = parser.parse_args()

# http://selenium-python.readthedocs.org/en/latest/api.html
if args.browser == 'chrome':
    caps = DesiredCapabilities.CHROME
elif args.browser == 'mobile_emulation':
    mobile_emulation = {"deviceName": "Google Nexus 5"}
    opts = webdriver.ChromeOptions()
    opts.add_experimental_option("mobileEmulation", mobile_emulation)
    caps = opts.to_capabilities()
elif args.browser == 'firefox':
    caps = DesiredCapabilities.FIREFOX
else:
    raise ValueError("Invalid browser '%s'" % args.browser)

msleep = float( os.environ.get('TEST_SLEEPS', '0.1') )

# http://selenium-python.readthedocs.org/en/latest/api.html
sel_proto = os.environ.get('SELENIUM_HUB_PROTO','http')
sel_host = os.environ.get('SELENIUM_HUB_HOST','localhost')
sel_port = os.environ.get('SELENIUM_HUB_PORT','4444')
myselenium_base_url = "%s://%s:%s" % (sel_proto, sel_host, sel_port)
myselenium_grid_console_url = "%s/grid/console" % (myselenium_base_url)
myselenium_hub_url = "%s/wd/hub" % (myselenium_base_url)
print ("Will use browser=%s" % args.browser)
print ("Will sleep '%s' secs between test steps" % msleep)

@retry(stop_max_attempt_number=12, stop_max_delay=30100, wait_fixed=300)
def webdriver_connect():
    print ("Will connect to selenium at %s" % myselenium_hub_url)
    # http://selenium-python.readthedocs.org/en/latest/getting-started.html#using-selenium-with-remote-webdriver
    return webdriver.Remote(command_executor=myselenium_hub_url, desired_capabilities=caps)

driver = webdriver_connect()
driver.implicitly_wait(10)
time.sleep(msleep)

# Set location top left and size to max allowed on the container
width = os.environ.get('SCREEN_WIDTH','800')
height = os.environ.get('SCREEN_HEIGHT','600')
driver.set_window_position(0, 0)
driver.set_window_size(width, height)

@retry(stop_max_attempt_number=5, stop_max_delay=20100, wait_fixed=100)
def open_hub_page():
    print ("Opening local selenium grid console page %s" %
           myselenium_grid_console_url)
    driver.get(myselenium_grid_console_url)

@retry(stop_max_attempt_number=5, stop_max_delay=20100, wait_fixed=100)
def check_hub_title():
    print ("Current title: %s" % driver.title)
    print ("Asserting 'Grid Console' in driver.title")
    assert "Grid Console" in driver.title

if args.browser == 'chrome':
    driver.set_window_size(1400, 660)
    # Selenium grid console - open
    open_hub_page()
    time.sleep(msleep)
    # zoom in
    driver.execute_script("document.body.style.zoom='150%'")
    time.sleep(msleep)

    # Selenium grid console - assert
    check_hub_title()

    # Selenium grid console - take screen shot
    screen_shot_path = '/test/console.png'
    print ("Taking screen shot and saving to %s" % screen_shot_path)
    driver.get_screenshot_as_file(screen_shot_path)

driver.set_window_size(width, height)

# Test: https://code.google.com/p/chromium/issues/detail?id=519952
# e.g. pageurl = "http://localhost:8080/adwords"
# e.g. pageurl = "http://www.google.com:80/adwords"
# e.g. pageurl = "https://www.google.com:443/adwords"
# e.g. pageurl = "http://d.host.loc.dev:8080/adwords"
page_port = os.environ.get('MOCK_SERVER_PORT','8080')
page_host = os.environ.get('MOCK_SERVER_HOST','localhost')
pageurl = ("http://%s:%s/adwords" % (page_host, page_port))

@retry(stop_max_attempt_number=7, stop_max_delay=20100, wait_fixed=300)
def open_web_page():
    print ("Opening page %s" % pageurl)
    driver.get(pageurl)
    time.sleep(msleep)
    print ("Current title: %s" % driver.title)
    print ("Asserting 'Google Adwords' in driver.title")
    assert "Google AdWords | Pay-per-Click-Onlinewerbung auf Google (PPC)" in driver.title

open_web_page()

if args.browser == 'mobile_emulation':
    pageurl = ("http://%s:%s/adwords/costs" % (page_host, page_port))
    print ("mobile_emulation test: Opening page %s" % pageurl)
    driver.get(pageurl)
    time.sleep(msleep)
else:
    print ("Click link 'Kosten'")
    link = driver.find_element_by_link_text('Kosten')
    link.click()
    driver.maximize_window()
    time.sleep(msleep)

@retry(stop_max_attempt_number=7, stop_max_delay=20100, wait_fixed=300)
def open_costs_page():
    print ("Current title: %s" % driver.title)
    print ("Asserting 'Kosten' in driver.title")
    assert "Kosten von Google AdWords | Google AdWords" in driver.title

open_costs_page()

if args.browser != 'mobile_emulation':
    print ("Go back to home page")
    link = driver.find_element_by_link_text('Übersicht')
    link.click()
    time.sleep(msleep)
    print ("Current title: %s" % driver.title)
    print ("Asserting 'Google (PPC)' in driver.title")
    assert "Google AdWords | Pay-per-Click-Onlinewerbung auf Google (PPC)" in driver.title
    time.sleep(msleep)

print ("Close driver and clean up")
driver.close()
time.sleep(msleep)

print ("All done. SUCCESS!")
try:
    driver.quit()
except:
    pass
