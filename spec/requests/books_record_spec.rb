require 'rails_helper'

RSpec.describe "本の登録", type: :request do
  let!(:user) { create(:user) }
  let!(:book) { create(:book, user: user) }

  context "ログインしているユーザーの場合" do
    before do
      get new_book_path
      login_for_request(user)
    end
 
    context "フレンドリーフォワーディング" do
      it "レスポンスが正常に表示されること" do
        expect(response).to redirect_to new_book_url
      end
    end

    it "有効な本データで登録できること" do
      expect {
        post books_path, params: { book: { name: "座右の銘",
                                            thoughts: "いろいろな人の考えが載っていて、とても勉強になりました"} }
      }.to change(Book, :count).by(1)
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end

    it "無効な本データでは登録できないこと" do
      expect {
        post books_path, params: { book: { name: "",
                                            thoughts: "いろいろな人の考えが載っていて、とても勉強になりました"} }
      }.not_to change(Book, :count)
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
