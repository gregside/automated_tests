require 'selenium-webdriver'
require 'rspec'

module BHHelper

  def initialize_selenium
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new
    @driver.manage.timeouts.implicit_wait = 5
    @driver.navigate.to 'http://localhost:3600/login'
  end

  # Logs in to FundFinder
  def login(username, password)
    
    username_field = @driver.find_element(:name, 'email')
    password_field = @driver.find_element(:name, 'password')
    terms_checkbox = @driver.find_element(css: '.bsg-Checkbox__input')
    login_button = @driver.find_element(css: '.bsg-Button--base')
    
    username_field.send_keys(username)
    password_field.send_keys(password)
    terms_checkbox.click
    login_button.click
    
    begin
      dashboard = @driver.find_element(css: '.main--bCdz5')
      puts "Logged in as #{username}"
    rescue Selenium::WebDriver::Error::NoSuchElementError
      puts "#{username} Failed login"
    end
  end

  # navigates back to search page
  def navigate_to_search
    @driver.get('http://localhost:3600/search')
  end

  # logs out of FundFinder
  def logout(username, password)
  @driver.find_element(css: '.button-label--wvtL3').click
   logout = @driver.find_element(css: '.bsg-Truncate__base')
   logout.click
      rescue
            puts "#{username} failed to log out"
      end
    end
    
  # changes 'search by type' field on search page
  def search_by_type(type) # type is 'HedgeFund' or 'CTA'
    type_to_search = @driver.find_element(xpath: "//input[@value='#{type}']") 
    type_to_search.click
    puts "Searching #{type} funds"
  end

  # specifies 'search by name' field
  def search_by_name(input)
    @driver.find_element(:class, "button--w4NlN").click

    text_field = @driver.find_element(:class, "BsgInput__input")

    text_field.send_keys(input)
    text_field.send_keys(:return)
    puts "Search by name set to search '#{input}'"
  end

  # presses search button on search page
  def execute_search
    puts "Executing search"
    search_button = @driver.find_element(:css, '.bsg-Button--primary > .bsg-Button-Children__Container')
    search_button.click
    @wait.until { @driver.find_elements(:css, "tr").any? }
    puts "Search executed"
  end

  # selects result from search results, with result_position being the position (1 -> first result, etc.)
  def search_select(result_position)
    result = @driver.find_element(css: "tr:nth-child(#{result_position}) a")
    result.click
  end

  # when on Fund page, specify a tab to view. If tab not clickable until timeout, try again 3 times
  def fund_tab_select(tab)
    
    tab_element = @driver.find_element(xpath: "//li[#{tab}]")
  

    attempts = 0
    max_attempts = 3

    begin
        tab_element.click
        @wait.until { @driver.find_elements(:xpath, "//div[@role='tabpanel']").any? }
    rescue Selenium::WebDriver::Error::ElementClickInterceptedError
        attempts += 1
        if attempts < max_attempts
            sleep 1
            retry
        else
            raise "Unable to click on tab #{tab} after #{max_attempts} attempts"
        end
    end
end 

include BHHelper