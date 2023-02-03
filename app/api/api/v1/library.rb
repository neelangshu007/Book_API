require 'grape'

module API::V1
    class Library < Grape::API
        resource :books do
            desc 'Create a book'
            params do
                requires :title, type: String, desc: 'Book title'
                requires :language, type: String, desc: 'Book language'
                requires :price, type: BigDecimal, desc: 'Book price'
                requires :author, type: String, desc: 'Book author'
                requires :isbn, type: String, desc: 'Book ISBN number'
            end
            post do
                # byebug
                book = Book.create!(declared(params))
                { id: book.id, title: book.title, language: book.language, price: book.price, author: book.author, isbn: book.isbn }
            end

            desc 'Create multiple books'
            params do
                requires :books, type: Array, desc: 'Array of books'
            end
            post '/bulk_create' do
                books = []
                params[:books].each do |book_params|
                    books << Book.create!({
                        title: book_params[:title],
                        language: book_params[:language],
                        price: book_params[:price],
                        author: book_params[:author],
                        isbn: book_params[:isbn]
                    })
                end
                {message: 'Books Created Successfully',books: books }
            end
  
            desc 'Update a book'
            params do
                requires :id, type: Integer, desc: 'Book ID'
                optional :title, type: String, desc: 'Book title'
                optional :language, type: String, desc: 'Book language'
                optional :price, type: BigDecimal, desc: 'Book price'
                optional :author, type: String, desc: 'Book author'
                optional :isbn, type: String, desc: 'Book ISBN number'
            end
            put ':id' do
                book = Book.find(params[:id])
                book.update(declared(params))
                { id: book.id, title: book.title, language: book.language, price: book.price, author: book.author, isbn: book.isbn }
            end


            desc 'Update multiple books'
            params do
                requires :books, type:Array, desc: 'Array of books'
            end
            put '/bulk_update' do
                books = []
                params[:books].each do |book_params|
                    book = Book.find(book_params[:id])
                    book.update({
                        title: book_params[:title] || book.title,
                        language: book_params[:language] || book.language,
                        price: book_params[:price] || book.price,
                        author: book_params[:author] || book.author,
                        isbn: book_params[:isbn] || book.isbn
                    })
                end
                {message: "Books Successfulyy Updated", books: books}
            end
        

            desc 'Delete a book'
            params do
                requires :id, type: Integer, desc: 'Book ID'
            end
            delete ':id' do
                book = Book.find(params[:id])
                book.destroy
            end
        
            desc 'Get book with highest price'
            get :highest_price do
                book = Book.order(price: :desc).first
                { id: book.id, title: book.title, language: book.language, price: book.price, author: book.author, isbn: book.isbn }
            end
        
            desc 'Get details of all the book with a given author name'
            params do
                requires :author, type: String, desc: 'Author name'
            end
            get :by_author do
                books = Book.where(author: params[:author])
                books.map { |book| { id: book.id, title: book.title, language: book.language, price: book.price, author: book.author, isbn: book.isbn } }
            end


            desc 'Get Details of All the Books'
            get do
                Book.all
            end


            desc 'Get Details of a Book by ID'
            params do
                requires :id, type: Integer, desc: 'Book ID'
            end
            get ':id' do
                book = Book.find(params[:id])
                {book: book }
            end


            desc 'Retrieve all books with a given language'
            params do
                requires :language, type: String, desc: "Book Language"
            end
            get '/language/:language' do
                books = Book.where(language: params[:language])
                {books: books }
            end

            desc 'Get Details of a Book by ISBN number'
            params do
                requires :isbn, type: String, desc: 'Book ISBN Number'
            end
            get '/isbn/:isbn' do
                book = Book.find_by(isbn: params[:isbn])
                {book: book }
            end

            desc 'Retrieve all books within a given price range'
            params do
                requires :min_price, type: Float, desc: 'Minimum book price'
                requires :max_price, type: Float, desc: 'Maximum book price'
            end
            get '/price_range/:min_price/:max_price' do
                books = Book.where(price: params[:min_price]..params[:max_price])
                {books: books }
            end

            desc 'Retrieve all books sorted by price'
            params do
                requires :order, type: String, desc: 'Sort order (asc or desc)'
            end
            get '/sort_by_price/:order' do
              order = params[:order] == 'asc' ? :asc : :desc
              books = Book.order(price: order)
              {books: books}
            end

        end
    end
end

