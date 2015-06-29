require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe 'GET #show' do
    context 'when user logged_in?' do
      login_user

      it 'renders dashboard page' do
        get :show
        expect(response).to render_template('show')
      end

      it 'displays tiny urls of logged in user only' do
        FactoryGirl.create(:tiny_url)
        tiny_url = FactoryGirl.create(:tiny_url, owner: controller.current_user)
        get :show
        expect(assigns[:tiny_urls].to_a).to eq([tiny_url])
      end
    end

    context 'when user not logged_in?' do
      it 'redirects to sign in page' do
        get :show
        expect(response).to redirect_to(new_user_session_path)
        flash[:alert].should == 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
