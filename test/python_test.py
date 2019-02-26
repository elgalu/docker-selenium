#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Dependencies
#  pip install -U selenium==3.3.1
# Usage
#  curl -sSL https://raw.github.com/dosel/t/i/s | python
import os
import sys
import time
import datetime
from retrying import retry

# Import the Selenium 2 namespace (aka "webdriver")
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException

import argparse
parser = argparse.ArgumentParser(description='Perform some basic selenium tests.')
parser.add_argument('browser', choices=['chrome', 'firefox', 'mobile_emulation'], nargs='?', default='chrome',
                    help='in which browser to test')
parser.add_argument('only_screenshot', choices=['true', 'false'], nargs='?', default='false',
                    help='if we just want to take selenium versions screen shots')

args = parser.parse_args()

# http://selenium-python.readthedocs.org/en/latest/api.html
if args.browser == 'chrome':
    caps = DesiredCapabilities.CHROME
    browserName = args.browser
elif args.browser == 'mobile_emulation':
    mobile_emulation = {"deviceName": "iPad"}
    opts = webdriver.ChromeOptions()
    opts.add_experimental_option("mobileEmulation", mobile_emulation)
    caps = opts.to_capabilities()
    browserName = 'chrome'
elif args.browser == 'firefox':
    caps = DesiredCapabilities.FIREFOX
    browserName = args.browser
else:
    raise ValueError("Invalid browser '%s'" % args.browser)

msleep = float( os.environ.get('TEST_SLEEPS', '0.01') )

# http://selenium-python.readthedocs.io/api.html#desired-capabilities
# Create a desired capabilities object as a starting point.
browserVersion = os.environ.get('CAPS_BROWSER_VERSION', '')

# http://selenium-python.readthedocs.org/en/latest/api.html
sel_proto = os.environ.get('SELENIUM_HUB_PROTO','http')
sel_host = os.environ.get('SELENIUM_HUB_HOST','localhost')
sel_port = os.environ.get('SELENIUM_HUB_PORT','4444')
myselenium_base_url = "%s://%s:%s" % (sel_proto, sel_host, sel_port)
myselenium_grid_console_url = "%s/grid/console" % (myselenium_base_url)
myselenium_hub_url = "%s/wd/hub" % (myselenium_base_url)
myselenium_hub_url = os.environ.get('SELENIUM_URL', myselenium_hub_url)

# Group tests by `build`
buildId = "%s%s" % (os.environ.get('JOB_NAME', ''), os.environ.get('BUILD_NUMBER', ''))
if buildId == '':
    buildId = 'dosel'

# Within `build` identify one test by `name`
nameId = os.environ.get('TEST_ID', 'test-adwords')

# Have a long Id for the log outpus
longId = "%s - %s - %s%s" % (buildId, nameId, browserName, browserVersion)

# Set location top left and size to max allowed on the container
width = os.environ.get('SCREEN_WIDTH','800')
height = os.environ.get('SCREEN_HEIGHT','600')

# Build the capabilities
caps = {'browserName': browserName}
caps['platform'] = os.environ.get('CAPS_OS_PLATFORM', 'ANY')
caps['version'] = browserVersion
# caps['tunnelIdentifier'] = os.environ.get('TUNNEL_ID', 'zalenium')
caps['tunnel-identifier'] = os.environ.get('TUNNEL_ID', 'zalenium')
# caps['screenResolution'] = "%sx%sx24" % (width, height)
caps['screenResolution'] = "%sx%s" % (width, height)
caps['name'] = nameId
caps['build'] = buildId
caps['recordVideo'] = 'false'

if args.browser == 'firefox':
    caps["moz:firefoxOptions"] = {
                "log": {
                    "level": "trace",
                },
            }

# https://selenium-python.readthedocs.io/getting-started.html#using-selenium-with-remote-webdriver
print ("%s %s - (01/15) Will connect to selenium at %s" % (datetime.datetime.utcnow(), longId, myselenium_hub_url))
try:
    driver = webdriver.Remote(command_executor=myselenium_hub_url, desired_capabilities=caps)
except:    
    print ("%s %s - Failed connecting to %s" %
           (datetime.datetime.utcnow(), longId, myselenium_grid_console_url))
    myselenium_hub_url="http://localhost:4444/wd/hub"
    print ("%s %s - Now trying to connect to %s" %
           (datetime.datetime.utcnow(), longId, myselenium_grid_console_url))
    driver = webdriver.Remote(command_executor=myselenium_hub_url, desired_capabilities=caps)

time.sleep(msleep)

def get_a_chrome_headless_driver():
    from selenium.webdriver.chrome.options import Options

    CHROME_PATH = '/usr/bin/google-chrome-stable'
    CHROMEDRIVER_PATH = '/home/user/bin/chromedriver'
    WINDOW_SIZE = "1920,1080"

    opts = Options()
    opts.add_argument("--headless")
    opts.add_argument("--window-size=%s" % WINDOW_SIZE)
    opts.binary_location = CHROME_PATH

    driver = webdriver.Chrome(executable_path=CHROMEDRIVER_PATH, chrome_options=opts)
    return driver

def is_element_present(how, what):
    try: driver.find_element(by=how, value=what)
    except NoSuchElementException: return False
    return True

driver.implicitly_wait(4)

driver.set_window_position(0, 0)
driver.set_window_size(width, height)

@retry(stop_max_attempt_number=8, stop_max_delay=20100, wait_fixed=200)
def open_hub_page():
    print ("%s %s - Opening local selenium grid console page %s" %
           (datetime.datetime.utcnow(), longId, myselenium_grid_console_url))
    driver.get(myselenium_grid_console_url)

@retry(stop_max_attempt_number=8, stop_max_delay=20100, wait_fixed=200)
def check_hub_title():
    print ("%s %s - Current title: %s" % (datetime.datetime.utcnow(), longId, driver.title))
    print ("%s %s - Asserting 'Grid Console' in driver.title" % (datetime.datetime.utcnow(), longId))
    assert "Grid Console" in driver.title

if args.browser == 'chrome':
    driver.set_window_size(1400, 500)
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

    if args.only_screenshot == 'true':
        sys.exit(0)

driver.set_window_size(width, height)

# Test: https://code.google.com/p/chromium/issues/detail?id=519952
# e.g. pageurl = "http://localhost:8280/adwords"
# e.g. pageurl = "http://www.google.com:80/adwords"
# e.g. pageurl = "https://www.google.com:443/adwords"
# e.g. pageurl = "http://d.host.loc.dev:8280/adwords"
page_port = os.environ.get('MOCK_SERVER_PORT','8280')
page_host = os.environ.get('MOCK_SERVER_HOST','localhost')
pageurl = ("http://%s:%s/adwords" % (page_host, page_port))

@retry(stop_max_attempt_number=20, stop_max_delay=40100, wait_fixed=300)
def open_web_page():
    print ("%s %s - (02/15) Opening page %s" % (datetime.datetime.utcnow(), longId, pageurl))
    driver.get(pageurl)
    time.sleep(msleep)
    print ("%s %s - (03/15) Current title: %s" % (datetime.datetime.utcnow(), longId, driver.title))
    print ("%s %s - (04/15) Asserting 'Google Adwords' in driver.title" % (datetime.datetime.utcnow(), longId))
    assert "Google AdWords | Pay-per-Click-Onlinewerbung auf Google (PPC)" in driver.title

open_web_page()

@retry(stop_max_attempt_number=12, stop_max_delay=5000, wait_fixed=300)
def mobile_emulation_get_costs():
    pageurl = ("http://%s:%s/adwords/costs" % (page_host, page_port))
    print ("%s %s - (04/15) mobile_emulation test: Opening page %s" % (datetime.datetime.utcnow(), longId, pageurl))
    driver.get(pageurl)

@retry(stop_max_attempt_number=40, stop_max_delay=40100, wait_fixed=300)
def click_kosten():
    print ("%s %s - (04/15) Click link 'Kosten'" % (datetime.datetime.utcnow(), longId))
    assert is_element_present(By.LINK_TEXT, "Kosten")
    link = driver.find_element_by_link_text('Kosten')
    assert link.is_displayed()
    link.click()

if args.browser == 'mobile_emulation':
    mobile_emulation_get_costs()
else:
    try:
        click_kosten()
    except:
        time.sleep(1)
        open_web_page()
        try:
            click_kosten()
        except:
            time.sleep(2)
            open_web_page()
            click_kosten()

time.sleep(msleep)

@retry(stop_max_attempt_number=20, stop_max_delay=40100, wait_fixed=300)
def assert_at_costs_page():
    print ("%s %s - (05/15) Current title: %s" % (datetime.datetime.utcnow(), longId, driver.title))
    print ("%s %s - (06/15) Asserting 'Kosten' in driver.title" % (datetime.datetime.utcnow(), longId))
    assert "Kosten von Google AdWords | Google AdWords" in driver.title

assert_at_costs_page()

print ("%s %s - (13/15) Will driver.maximize_window()" % (datetime.datetime.utcnow(), longId))
driver.maximize_window()

@retry(stop_max_attempt_number=40, stop_max_delay=40100, wait_fixed=300)
def assert_overview_page():
    print ("%s %s - (07/15) Go back to home page" % (datetime.datetime.utcnow(), longId))
    assert is_element_present(By.LINK_TEXT, 'Übersicht')
    link = driver.find_element_by_link_text('Übersicht')
    assert link.is_displayed()
    link.click()
    time.sleep(msleep)
    print ("%s %s - (10/15) Current title: %s" % (datetime.datetime.utcnow(), longId, driver.title))
    print ("%s %s - (11/15) Asserting 'Google (PPC)' in driver.title" % (datetime.datetime.utcnow(), longId))
    assert "Google AdWords | Pay-per-Click-Onlinewerbung auf Google (PPC)" in driver.title
    time.sleep(msleep)

if args.browser != 'mobile_emulation':
    assert_overview_page()

# https://github.com/mozilla/geckodriver/issues/957
# print ("%s %s - (12/15) Test done - will driver.close()" % (datetime.datetime.utcnow(), longId))
# driver.close()
# time.sleep(msleep)

print ("%s %s - (14/15) Test done - will driver.quit()" % (datetime.datetime.utcnow(), longId))
driver.quit()
print ("%s %s - (15/15) All done. SUCCESS! - DONE driver.quit()" % (datetime.datetime.utcnow(), longId))
