require 'selenium-webdriver'
require 'rspec-expectations'

BROWSERS = { firefox: '27', chrome: '32', internet_explorer: '8' }
def setup(browser_name, browser_version)
  caps = Selenium::WebDriver::Remote::Capabilities.send(browser_name.to_sym)
  caps.platform   = 'Windows XP'
  caps.version = browser_version.to_s
	caps[:name] = "Run one tests on multiple browsers in parallel"

  Thread.current[:driver] = Selenium::WebDriver.for(:remote,
                                                    :url => "http://gajananrmahajan:ed791c9a-51fc-44bf-a61a-90e1181276b9@ondemand.saucelabs.com:80/wd/hub",
                                                    :desired_capabilities => caps)
end

def teardown
  Thread.current[:driver].quit
end

def run
  threads = []
  BROWSERS.each_pair do |browser_name, browser_version|
    threads << Thread.new do
      setup(browser_name, browser_version)
      yield
      teardown
    end
    threads.each { |thread| thread.join }
  end
end

run do
  Thread.current[:driver].get "http://www.google.com"
  Thread.current[:driver].title.should == 'Google'
end
