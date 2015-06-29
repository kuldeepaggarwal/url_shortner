module ControllerMacros
  extend ActiveSupport::Concern

  module ClassMethods
    def login_user(params = {})
      before do
        @request.env['devise.mapping'] = Devise.mappings[:account]
        @current_user = FactoryGirl.create(:user, params)
        sign_in @current_user
      end
    end
  end
end
