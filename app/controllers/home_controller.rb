class HomeController < ApplicationController
  def index
    render plain: "Welcome to my issue tracker"
  end
end
