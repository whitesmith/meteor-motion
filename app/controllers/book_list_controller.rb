class BookListController < UIViewController
	attr_accessor :meteor

	def viewDidLoad
		super
		self.view.backgroundColor = UIColor.whiteColor
		self.title = "Books"

		@table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview @table

    @table.dataSource = self
    @table.delegate = self

    @books = @meteor.collections['books']
    @books.add_observer(@table.method(:reloadData))

    right_button = UIBarButtonItem.alloc.initWithTitle("Add Book", style: UIBarButtonItemStyleDone, target:self, action:'add_book')
  	self.navigationItem.rightBarButtonItem = right_button
	end

	def add_book
		book = {}
	  form = build_book_form( book )

	  bookController = BookController.alloc.initWithForm(form)
	  bookController.meteor = @meteor
	  bookController._id = nil

	  self.navigationController.pushViewController(bookController, animated: true)
	end


	def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    cell.textLabel.text = @books.all[indexPath.row]['title']

    cell
  end


  def tableView(tableView, numberOfRowsInSection: section)
    @books.size
  end


  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
	  tableView.deselectRowAtIndexPath(indexPath, animated: true)

	  book = @books.all[indexPath.row]
	  form = build_book_form( book )

	  bookController = BookController.alloc.initWithForm(form)
	  bookController.meteor = @meteor
	  bookController._id = book[:_id]

	  self.navigationController.pushViewController(bookController, animated: true)
	end


	def build_book_form book
		form = Formotion::Form.new

		form.build_section do |section|
		  section.title = "Book Details"

		  section.build_row do |row|
		    row.title = "Title"
		    row.key = :title
		    row.type = :string
	  		row.placeholder = 'Book title'
	  		row.value = book['title']
		  end

		  section.build_row do |row|
		    row.title = "Author"
		    row.key = :author
		    row.type = :string
	  		row.placeholder = 'Book author'
	  		row.value = book['author']
		  end

		  section.build_row do |row|
		    row.title = "Year"
		    row.key = :year
		    row.type = :string
	  		row.placeholder = 'Book year'
	  		row.value = book['year']
		  end

		  section.build_row do |row|
		  	row.title = 'Save Changes'
		  	row.type = :submit
		  end
		end

		return form
	end

end