require 'selenium-webdriver'
require 'rspec-expectations'

class GoogleSearch
  SEARCH_BOX = { id: 'gbqfq' }
  TOP_SEARCH_RESULT = { css: '#rso .g'  }
  ENV['base_url'] = 'http://www.google.com'
  attr_reader :driver

  def initialize driver
    @driver = driver
    visit
    verify_page
  end

  def visit
    @driver.get ENV['base_url']
  end

  def search_for(search_term)
    @driver.find_element(SEARCH_BOX).clear
    @driver.find_element(SEARCH_BOX).send_keys search_term
    @driver.find_element(SEARCH_BOX).submit
  end

  def search_result_present?(search_result)
    wait_for(5) { displayed?(TOP_SEARCH_RESULT) }
    @driver.find_element(TOP_SEARCH_RESULT).text.include? search_result
  end

  private
  def verify_page
    @driver.title.include?('Google').should == true
  end

  def wait_for(seconds)
    Selenium::WebDriver::Wait.new(:timeout => seconds).until{ yield }
  end

  def displayed?(locator)
    @driver.find_element(locator).displayed?
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
end

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
  google = GoogleSearch.new(@driver)
  google.search_for 'elemental selenium tips'
  result = google.search_result_present? "Receive a Free, Weekly Tip"
  result.should == true
end
