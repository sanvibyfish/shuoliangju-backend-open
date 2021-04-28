class AdminConstraint
  def matches?(request)
    # return false if !request.session[:user_id]
    # user = User.find(request.session[:user_id])
    # user && user.admin?
  end
end
