require 'selenium-webdriver'
require 'rspec-expectations'

def setup
  @driver = Selenium::WebDriver.for :firefox
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

def wait_for(seconds = 8)
  Selenium::WebDriver::Wait.new(:timeout => 8).until { yield }
end

run do
  @driver.get 'http://the-internet.herokuapp.com/dynamic_loading/2'
  @driver.find_element(css: '#start button').click
  wait_for { @driver.find_element(css: '#finish').displayed? }
  @driver.find_element(css: '#finish').text.should =~ /Hello World!/
end