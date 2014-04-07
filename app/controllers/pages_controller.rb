class PagesController < ApplicationController
skip_before_filter :authenticate_user!, only: [:index]

  def index
    render layout: 'landing'
  end

  def profile
    @users = User.all
  end
end