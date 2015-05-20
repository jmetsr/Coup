require 'spec_helper'
require 'rails_helper'
require 'database_cleaner'
feature "starting a game", :js => true do
	it 'can start a game' do
		in_browser(:one) do
  	 		login_as('john')
  		end
 	 	in_browser(:two) do  
        	 login_as('Tom')
			 page.check("player")
			 click_button 'Propose Game with:'
  		end

  		in_browser(:one) do
  			click_button('yes')
  		end
  		in_browser(:two) do  
  			click_button('yes')
  			page.should have_content 'game'
  		end
  		in_browser(:one) do
  			page.should have_content 'game'
  			click_button('LOGOUT')
  		end
  		in_browser(:two) do
  			click_button('LOGOUT')
  		end


	end
end

