class ConnectionController < UIViewController

	def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    @label = UILabel.alloc.initWithFrame(CGRectZero)
    @label.text = "Connecting..."
    @label.sizeToFit
    @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
    self.view.addSubview @label

		@meteorClient = MeteorMotion::Client.new
		@meteorClient.on_error( self.method(:meteor_error) )
		@meteorClient.connect 'localhost', 3000, self.method(:connected)

  end

  def connected result, details
		if result
			@meteorClient.add_collection('books')
			@meteorClient.subscribe('books')

			form = buildLoginForm

			@controller = LoginController.alloc.initWithForm(form)
			@controller.meteor = @meteorClient

  		self.presentViewController( @controller, animated: true, completion: nil )
  	else
  		exit(0)
  	end
	end

  # Meteor basic error handler - alert error to screen
  #
  def meteor_error code, reason, details
  	if reason != :unknown
  		alert = UIAlertView.new
  		alert.message = reason.to_s
  		alert.addButtonWithTitle "OK"
  		alert.show
  	else
  		puts "Meteor Error: #{reason}. Details: #{details}"
  	end
  end


  def buildLoginForm
  	form = Formotion::Form.new

		form.build_section do |section|
		  section.title = "Credentials"

		  section.build_row do |row|
		    row.title = "Username"
		    row.key = :user
		    row.type = :string
		    row.auto_correction = :no
	  		row.auto_capitalization = :none
	  		row.placeholder = 'Your username'
		  end

		  section.build_row do |row|
		    row.title = "Password"
		    row.key = :pass
		    row.type = :string
		    row.secure = true
		    row.auto_correction = :no
	  		row.auto_capitalization = :none
	  		row.placeholder = 'Your password'
		  end

		  section.build_row do |row|
		  	row.title = 'Submit'
		  	row.type = :submit
		  end
		end

		return form
  end

end