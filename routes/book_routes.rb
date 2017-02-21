module Sinatra
  module BookRoutes
    def self.registered(app)

      app.helpers do
        def serialize(book)
          BookSerializer.new(book).to_json
        end

        def book
          @book ||= Book.where(id: params[:id]).first
        end
      end

      app.get '/books' do
        books = Book.all
        [:title, :isbn, :author].each do |filter|
          books = books.send(filter, params[filter]) if params[filter]
        end
        books.map {|book| BookSerializer.new(book)}.to_json
      end

      app.get '/books/:id' do |id|
        halt_if_not_found!
        serialize(book)
      end

      app.post '/books' do
        book = Book.new(json_params)
        halt 422, serialize(book) unless book.save
        response.headers['Location'] = "#{base_url}/api/v1/books/#{book.id}"
        status 201
      end

      app.patch '/books/:id ' do |id|
        halt_if_not_found!
        halt 422, serialize(book) unless book.update_attributes(json_params)
        serialize(book)
      end

      app.delete '/books/:id' do |id|
        book.destroy if book
        status 204
      end
    end
  end
  register BookRoutes
end
