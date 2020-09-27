require 'rails_helper'

RSpec.describe "本の登録", type: :request do
  let!(:user) { create(:user) }
  let!(:book) { create(:book, user: user) }

  context "ログインしているユーザーの場合" do
    it "レスポンスが正常に表示されること" do
      login_for_request(user)
      get new_book_path
      expect(response).to have_http_status "200"
      expect(response).to render_template('books/new')
    end
  end

  context "ログインしていないユーザーの場合" do
    it "ログイン画面にリダイレクトすること" do
      get new_book_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
