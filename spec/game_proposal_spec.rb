require 'spec_helper'
require 'rails_helper'
require 'database_cleaner'

feature "proposing games", :js => true do

	it 'can propose a game' do

		in_browser(:one) do
    	x = String(rand(0))
  	 	login_as(x)
  	end
 	 	in_browser(:two) do
			x = String(rand(0))
  	 	login_as(x)
			page.check("player")
			click_button 'Propose Game with:'
			page.should have_content 'Play this game?'
  	end

  	in_browser(:one) do
  		page.should have_content 'Play this game?'
      click_button('LOGOUT')
  	end
    in_browser(:two) do
      click_button('LOGOUT')
    end

  end

end
feature "accepting and rejecting", :js => true do

  	it 'can accept a game' do
  
  		in_browser(:one) do
  	 		login_as('john')
  		end
 	 	  in_browser(:two) do
			  x = String(rand(0))
        login_as(x)
  	 		
			  page.check("player")
			  click_button 'Propose Game with:'
  		end

  		in_browser(:one) do
  			click_button('yes')
  			page.should have_content 'john accepts'
  		end

  		in_browser(:two) do
  			page.should have_content 'john accepts'
        click_button('LOGOUT')
  		end
      in_browser(:one) do
        click_button('LOGOUT')

      end
  	end

  	it 'can reject a game' do
  		in_browser(:one) do
  	 		login_as('jack')
  		end
 	 	  in_browser(:two) do
  	 	  login_as('tom')
			  page.check("player")
			  click_button 'Propose Game with:'
  		end

  		in_browser(:one) do
  			click_button('no')
  			page.should have_content 'jack rejects'
  		end

  		in_browser(:two) do
  			page.should have_content 'jack rejects'
  		end
  	end
  
end

