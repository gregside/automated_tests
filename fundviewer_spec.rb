require './BHHelper'

describe 'FundFinder views' do
  include BHHelper

  before(:all) do
    initialize_selenium
    @username = 'jake@email.com'
    @password = '123'
    login(@username, @password)
  end

  it 'can navigate through HF tabs' do
    for i in 1..5                             # range is search result links clicked 
      search_by_type('HedgeFund')             # run search by type
      execute_search
      search_select(i)
      puts "Accessed fund #{i}"
      for j in 2..9                           # HF is 2-9, CTA is 2-8
        fund_tab_select(j)
        puts "Viewed tab #{j}"
      end
      navigate_to_search                      # go back to search page
    end
  end

  it 'can navigate through CTA tabs' do       # same as above but for CTA funds
    for i in 1..5                            
      search_by_type('CTA')                  
      execute_search
      search_select(i)
      puts "Accessed fund #{i}"
      for j in 2..8                          
        fund_tab_select(j)
        puts "Viewed tab #{j}"
      end
      navigate_to_search                      
    end
  end

  after(:all) do
    logout(@username, @password)
    @driver.quit
  end
end
