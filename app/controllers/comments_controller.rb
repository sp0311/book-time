class CommentsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @book = Book.find(params[:book_id])
    @user = @book.user
    @comment = @book.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if !@book.nil? && @comment.save
      flash[:success] = "コメントを追加しました！"
    else
      flash[:danger] = "空のコメントは投稿できません。"
    end
    redirect_to request.referrer || root_url
  end

  def destroy
  end
end
