require 'spec_helper'
require 'rails_helper'
require 'database_cleaner'



feature "Loging in", :js => true do
  it "can try to login" do

    visit "http://localhost:3000/#/"
    page.should have_content 'Nickname'
  end

  it "can login" do
  	 x = String(rand(0))
  	 login_as(x)
	   page.should have_content x
     click_button('LOGOUT')
  end

  it "can have multiple users login" do

  	in_browser(:one) do
    	login_as('bob')
  	end
  	in_browser(:two) do
		  y = String(rand(0))
		  login_as(y)
  	 	page.should have_content 'bob'
      click_button('LOGOUT')
  	end
      
    end

end