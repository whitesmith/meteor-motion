class BookController < Formotion::FormController
	attr_accessor :meteor, :_id

	def viewDidLoad
		super
		self.title = "Details"
	end

	def viewWillAppear animated
		super
		@books = @meteor.collections['books']
    @books.add_observer( self.method(:update_form) )

    self.form.on_submit do |form|
			data = form.render
			self.view.endEditing(true)

			if @_id != nil
				@meteor.call('/books/update', self.method(:handle_update), [{_id: @_id},{title: data[:title], author: data[:author],year: data[:year]}])
			else
				new_id = SecureRandom.hex
				@meteor.call('/books/insert', self.method(:handle_update), [{_id: new_id,title: data[:title], author: data[:author],year: data[:year]}])
			end

		end

		if @_id != nil
			right_button = UIBarButtonItem.alloc.initWithTitle("Remove", style: UIBarButtonItemStyleDone, target:self, action:'remove')
	  	self.navigationItem.rightBarButtonItem = right_button
	  end
  end

	def viewWillDisappear animated
		super
		@books.remove_observer( self.method(:update_form) )
	end


	def update_form action, id
		if id == @_id
			if action == :removed
				self.navigationController.popViewControllerAnimated(true)
			elsif action == :changed
				book = @books.find(id)
				self.form.row(:title).value = book['title']
				self.form.row(:author).value = book['author']
				self.form.row(:year).value = book['year']
			end
		end
	end

	def handle_update action, result
		if action == :error
			alert = UIAlertView.new
  		alert.message = "Error: #{result['reason'].to_s}"
  		alert.addButtonWithTitle "OK"
  		alert.show
		elsif action == :result
			alert = UIAlertView.new
			if @_id != nil
  			alert.message = "Book updated sucessfully"
  			alert.addButtonWithTitle "OK"
  			alert.show	
  		else
  			alert.message = "Book added sucessfully"
  			alert.addButtonWithTitle "OK"
  			alert.show	
  			self.navigationController.popViewControllerAnimated(true)
  		end
		end
	end

	def handle_remove action, result
		if action == :error
			alert = UIAlertView.new
  		alert.message = "Error: #{result['reason'].to_s}"
  		alert.addButtonWithTitle "OK"
  		alert.show
		elsif action == :result
			alert = UIAlertView.new
  		alert.message = "Book removed sucessfully"
  		alert.addButtonWithTitle "OK"
  		alert.show
		end
	end


	def remove
		@meteor.call('/books/remove', self.method(:handle_remove), [{_id: @_id}])
	end

end