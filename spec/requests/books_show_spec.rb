require "rails_helper"

RSpec.describe "本個別ページ", type: :request do
  let!(:user) { create(:user) }
  let!(:book) { create(:book, user: user) }

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること" do
      login_for_request(user)
      get book_path(book)
      expect(response).to have_http_status "200"
      expect(response).to render_template('books/show')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      get book_path(book)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
