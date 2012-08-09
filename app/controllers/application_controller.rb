class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter { |c| Authorization.current_user = c.current_user }
  protect_from_forgery
end
