class ApplicationController < ActionController::Base
  before_action :set_search
  protect_from_forgery with: :exception
  include SessionsHelper

  # フィードから検索条件に該当する本を検索
  def set_search
    if logged_in?
      @search_word = params[:q][:name_cont] if params[:q]
      @q = Book.paginate(page: params[:page], per_page: 5).ransack(params[:q])
      @books = @q.result(distinct: true)
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end
end
