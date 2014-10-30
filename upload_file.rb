# This script demonstrates how to upload a file without dealing with
# dialog box and passing path of file to element to upload it.

require 'selenium-webdriver'
require 'rspec-expectations'
include RSpec::Matchers

def setup
  @driver = Selenium::WebDriver.for :firefox
  @driver.manage.window.maximize
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
  file = "happy.jpg"
  file_path = File.join(Dir.pwd + "/test_data", file).gsub("/", "\\\\")
  @driver.get "http://the-internet.herokuapp.com/upload"
  @driver.find_element(:id, "file-upload").send_keys file_path
  @driver.find_element(:id, "file-submit").click

  uploaded_file = @driver.find_element(:id, "uploaded-files").text
  uploaded_file.should eql file
end

