require "rails_helper"

RSpec.describe "本の編集", type: :request do
  let!(:user) { create(:user) }
  let!(:book) { create(:book, user: user) }

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること" do
      login_for_request(user)
      get edit_book_path(book)
      expect(response).to render_template('books/edit')
      patch book_path(book), params: { book: { name: "座右の銘",
                                               thoughts: "いろいろな人の考えが載っていて、とても勉強になりました" } }
      redirect_to book
      follow_redirect!
      expect(response).to render_template('books/show')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      # 編集
      get edit_book_path(book)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      # 更新
      patch book_path(book), params: { book: { name: "座右の銘",
                                               thoughts: "いろいろな人の考えが載っていて、とても勉強になりました" } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
