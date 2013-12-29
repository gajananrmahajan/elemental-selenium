# This script is to test iPhone app on sauce labs

require 'selenium-webdriver'
require 'rspec-expectations'

def setup
  caps = {
    'platform' => 'Mac 10.8',
    'version' => '6.1',
    'device' => 'iPhone Simulator',
    'app' => 'http://appium.s3.amazonaws.com/TestApp6.0.app.zip',
    'name' => 'Ruby/iPhone example for Appium'
  }

  @driver = Selenium::WebDriver.for(
    :remote,
    :url => 'http://gajananrmahajan:ed791c9a-51fc-44bf-a61a-90e1181276b9@ondemand.saucelabs.com:80/wd/hub',
    :desired_capabilities => caps
  )
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

run do
  # Following is my logic
=begin
  text_fields = @driver.find_elements(:tag_name, 'textField')
  text_fields[0].send_keys 10
  text_fields[1].send_keys 20

  @driver.find_element(:tag_name, 'button').click
  @driver.find_element(:tag_name, 'staticText').text.should == '30'
=end

  # Following is elemental-selenium logic

  values = [rand(10), rand(10)]
  expected_sum = values.reduce(&:+)

  elements = @driver.find_elements(:tag_name, 'textField')
  elements.each_with_index do |element, index|
    element.send_keys values[index]
  end

  @driver.find_element(:tag_name, 'button').click
  @driver.find_element(:tag_name, 'staticText').text.should == expected_sum.to_s
end
