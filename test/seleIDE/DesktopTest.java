package com.example.tests;

import java.util.regex.Pattern;
import java.util.concurrent.TimeUnit;
import org.junit.*;
import static org.junit.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import org.openqa.selenium.*;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.Select;

public class DesktopTest {
  private WebDriver driver;
  private String baseUrl;
  private boolean acceptNextAlert = true;
  private StringBuffer verificationErrors = new StringBuffer();

  @Before
  public void setUp() throws Exception {
    driver = new FirefoxDriver();
    baseUrl = "https://www.zalando.co.uk";
    driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
  }

  @Test
  public void testDesktopTest() throws Exception {
    driver.get(baseUrl + "/customer-logout");
    driver.get(baseUrl + "/category/women-shoes/products?gender=FEMALE");
    assertTrue(isElementPresent(By.xpath("//div[7]/div/div[3]")));
    assertTrue(isElementPresent(By.xpath("//div[18]/div[3]")));
    assertTrue(isElementPresent(By.xpath("//div[@id='slider-range']/div/div")));
    assertTrue(isElementPresent(By.cssSelector("div.filter-checkbox-wrapper > div.checkbox > label")));
    driver.findElement(By.cssSelector("div.filter-checkbox-wrapper > div.checkbox > label")).click();
    driver.findElement(By.cssSelector("div.filter-apply")).click();
    try {
      assertTrue(driver.findElement(By.cssSelector("input.filter-tag-id")).isSelected());
    } catch (Error e) {
      verificationErrors.append(e.toString());
    }
    String url = driver.getCurrentUrl();
    // ERROR: Caught exception [ERROR: Unsupported command [getEval | new RegExp(‘tags=attribute_tag.([0-9]+)’).exec(‘${url}’)[1] | ]]
    System.out.println("$(urlHasTags)");
  }

  @After
  public void tearDown() throws Exception {
    driver.quit();
    String verificationErrorString = verificationErrors.toString();
    if (!"".equals(verificationErrorString)) {
      fail(verificationErrorString);
    }
  }

  private boolean isElementPresent(By by) {
    try {
      driver.findElement(by);
      return true;
    } catch (NoSuchElementException e) {
      return false;
    }
  }

  private boolean isAlertPresent() {
    try {
      driver.switchTo().alert();
      return true;
    } catch (NoAlertPresentException e) {
      return false;
    }
  }

  private String closeAlertAndGetItsText() {
    try {
      Alert alert = driver.switchTo().alert();
      String alertText = alert.getText();
      if (acceptNextAlert) {
        alert.accept();
      } else {
        alert.dismiss();
      }
      return alertText;
    } finally {
      acceptNextAlert = true;
    }
  }
}
