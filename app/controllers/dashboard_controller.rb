class DashboardController < ApplicationController
  def show
    @tiny_urls = current_user.tiny_urls.ordered
  end
end
