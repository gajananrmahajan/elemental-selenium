# This script is about testing android app on Sauce labs

require 'selenium-webdriver'
require 'rspec-expectations'

def setup
  caps = {
    'platform' => 'Linux',
    'version' => '4.2',
    'device' => 'Android',
    'app' => 'http://appium.s3.amazonaws.com/NotesList.apk',
    'app-package' => 'com.example.android.notepad',
    'app-activity' => '.NotesList',
    'name' => 'Ruby/Android Example for Appium'
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
  @driver.find_element(:name, 'New note').click
  @driver.find_element(:tag_name, 'textfield').send_keys 'This is a new note, from Ruby'
  @driver.find_element(:name, 'Save').click

  notes = @driver.find_elements(:tag_name, 'text')
  notes[2].text.should == 'This is a new note, from Ruby'
end
