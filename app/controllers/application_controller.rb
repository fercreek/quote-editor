class ApplicationController < ActionController::Base
  before_action -> { sleep 1 }
end
