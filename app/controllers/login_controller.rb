class LoginController < Formotion::FormController
	attr_accessor :meteor

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    self.title = "Login"

    self.form.on_submit do |form|
    	data = form.render
    	self.view.endEditing(true)

    	@meteor.login_with_username( data[:user], data[:pass], self.method(:login_handler) )
    end

  end

  def login_handler action, details
  	if action == :success
  		controller = BookListController.alloc.initWithNibName(nil, bundle: nil)
			controller.meteor = @meteor
			navigationController = UINavigationController.alloc.initWithRootViewController(controller)

			self.presentViewController(navigationController , animated: true, completion: nil)

  	elsif action == :error
  		alert = UIAlertView.new
  		alert.message = "Error: #{details['reason'].to_s}"
  		alert.addButtonWithTitle "OK"
  		alert.show
  	end
  end

end