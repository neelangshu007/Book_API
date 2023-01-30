require 'grape'

module API::V1
    class Book < Grape::API
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
                byebug
                book = Book.create!(params)
                { id: book.id, title: book.title, language: book.language, price: book.price, author: book.author, isbn: book.isbn }
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
            get "details" do
                book = Book.get_all_books
                {details: book}
            end

        end
    end
end

