class BooksController < ApplicationController
  before_action :logged_in_user

  def new
    @book = Book.new
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      flash[:success] = "本が登録されました！"
      redirect_to root_url
    else
      render 'books/new'
    end
  end

  private

  def book_params
    params.require(:book).permit(:name, :thoughts)
  end
end