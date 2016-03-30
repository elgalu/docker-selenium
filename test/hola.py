#!/usr/bin/env python

# To install the Python client library:
# pip install -U selenium
import time
import os

# Import the Selenium 2 namespace (aka "webdriver")
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

import argparse
parser = argparse.ArgumentParser(description='Perform some basic selenium tests.')
parser.add_argument('browser', choices=['chrome', 'firefox'], nargs='?', default='chrome',
                    help='in which browser to test')
args = parser.parse_args()

# http://selenium-python.readthedocs.org/en/latest/api.html
if args.browser == 'chrome':
    caps = DesiredCapabilities.CHROME
elif args.browser == 'firefox':
    caps = DesiredCapabilities.FIREFOX
else:
    raise ValueError("Invalid browser '%s'", args.browser)

msleep = float( os.environ.get('TEST_SLEEPS', '0.1') )

# http://selenium-python.readthedocs.org/en/latest/api.html
sel_host = os.environ.get('SELENIUM_HUB_HOST','localhost')
sel_port = os.environ.get('SELENIUM_HUB_PORT','4444')
myselenium_base_url = "http://%s:%s" % (sel_host, sel_port)
myselenium_grid_console_url = "%s/grid/console" % (myselenium_base_url)
myselenium_hub_url = "%s/wd/hub" % (myselenium_base_url)
print ("Will use browser=%s" % args.browser)
print ("Will connect to selenium at %s" % myselenium_hub_url)
print ("Will sleep '%s' secs between test steps" % msleep)

# http://selenium-python.readthedocs.org/en/latest/getting-started.html#using-selenium-with-remote-webdriver
driver = webdriver.Remote(command_executor=myselenium_hub_url, desired_capabilities=caps)
driver.implicitly_wait(10)
time.sleep(msleep)

# Set location top left and size to max allowed on the container
width = os.environ.get('SCREEN_WIDTH','800')
height = os.environ.get('SCREEN_HEIGHT','600')
driver.set_window_position(0, 0)
driver.set_window_size(width, height)

if args.browser == 'chrome':
    driver.set_window_size(1400, 500)
    # Selenium grid console - open
    print ("Opening local selenium grid console page %s" %
           myselenium_grid_console_url)
    driver.get(myselenium_grid_console_url)
    time.sleep(msleep)
    # zoom in
    driver.execute_script("document.body.style.zoom='150%'")
    time.sleep(msleep)

    # Selenium grid console - assert
    print ("Current title: %s" % driver.title)
    print ("Asserting 'Grid Console' in driver.title")
    assert "Grid Console" in driver.title

    # Selenium grid console - take screen shot
    screen_shot_path = '/test/console.png'
    print ("Taking screen shot and saving to %s", screen_shot_path)
    driver.get_screenshot_as_file(screen_shot_path)

driver.set_window_size(width, height)

# Test: https://code.google.com/p/chromium/issues/detail?id=519952
pageurl = "http://www.google.com/adwords"
print ("Opening page %s" % pageurl)
driver.get(pageurl)
time.sleep(msleep)

print ("Current title: %s" % driver.title)
print ("Asserting 'Google Adwords' in driver.title")
assert "Google AdWords" in driver.title

pageurl = "http://www.python.org"
print ("Opening page %s" % pageurl)
driver.get(pageurl)
time.sleep(msleep)

print ("Asserting 'Python' in driver.title")
assert "Python" in driver.title

print ("Finding element by name: q")
elem = driver.find_element_by_name("q")

print ("Sending keys 'pycon'")
elem.send_keys("pycon")
time.sleep(msleep)

print ("Sending RETURN key")
elem.send_keys(Keys.RETURN)

print ("Ensure no results were found")
assert "No results found." not in driver.page_source

print ("Close driver and clean up")
driver.close()
time.sleep(msleep)

print ("All done. SUCCESS!")
driver.quit()
