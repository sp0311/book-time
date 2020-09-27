class BooksController < ApplicationController
  before_action :logged_in_user

  def new
    @book = Book.new
  end
end