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

run do
  @driver.get 'http://the-internet.herokuapp.com/tables'
  websites = @driver.find_elements(:css, '#table1 tbody tr td:nth-of-type(5)')
  websites = websites.map do |website|
    website.text
  end
  websites.size.should == 4

  dues = @driver.find_elements(:css, '#table1 tbody tr td:nth-of-type(4)')
  dues_values = []
  dues.each do |due|
    dues_values << due.text.gsub(/\$/, '').to_i
  end

  (dues_values == dues_values.sort).should == false
end
