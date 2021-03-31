class DeviseFailure < Devise::FailureApp
  def route(scope)
     scope.to_sym == :user ? :root_url : super
  end
end
