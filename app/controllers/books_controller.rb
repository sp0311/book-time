class BooksController < ApplicationController
  before_action :logged_in_user

  def show
    @book = Book.find(params[:id])
  end
  
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

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:success] = "本の情報が更新されました！"
      redirect_to @book
    else
      render 'edit'
    end
  end

  private

  def book_params
    params.require(:book).permit(:name, :thoughts)
  end
end