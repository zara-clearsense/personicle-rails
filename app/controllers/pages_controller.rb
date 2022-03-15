class PagesController < ApplicationController
  before_action :require_user, except: [:login,:register]
  layout :resolve_layout
  
  private

  def resolve_layout
    case action_name
    when 'login', 'register'
      'authentication'
    else
      'dashboard'
    end
  end
end
