class BooksController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]

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

  def destroy
    @book = Book.find(params[:id])
    if current_user.admin? || current_user?(@book.user)
      @book.destroy
      flash[:success] = "本が削除されました"
      redirect_to request.referrer == user_url(@book.user) ? user_url(@book.user) : root_url
    else
      flash[:danger] = "他人の本は削除できません"
      redirect_to root_url
    end
  end

  private

  def book_params
    params.require(:book).permit(:name, :thoughts, :picture)
  end

  def correct_user
    # 現在のユーザーが更新対象の本を保有しているかどうか確認
    @book = current_user.books.find_by(id: params[:id])
    redirect_to root_url if @book.nil?
  end
end
