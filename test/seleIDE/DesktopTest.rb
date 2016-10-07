require "rubygems"
gem "rspec"
gem "selenium-client"
require "selenium/client"
require "selenium/rspec/spec_helper"
require "spec/test/unit"

describe "DesktopTest" do
  attr_reader :selenium_driver
  alias :page :selenium_driver

  before(:all) do
    @verification_errors = []
    @selenium_driver = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*chrome",
      :url => "https://www.zalando.co.uk",
      :timeout_in_second => 60
  end

  before(:each) do
    @selenium_driver.start_new_browser_session
  end

  append_after(:each) do
    @selenium_driver.close_current_browser_session
    @verification_errors.should == []
  end

  it "test_desktop" do
    page.open "/brands/men/"
    page.wait_for_page_to_load "9000"
    begin
        page.is_element_present("css=.header").should be_true
    rescue ExpectationNotMetError
        @verification_errors << $!
    end
    url = page.get_location
    puts "Last url: #{url}"
  end
end
