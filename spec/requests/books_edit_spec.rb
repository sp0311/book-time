require "rails_helper"

RSpec.describe "本の編集", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:book) { create(:book, user: user) }
  let(:picture2_path) { File.join(Rails.root, 'spec/fixtures/test_book2.jpg') }
  let(:picture2) { Rack::Test::UploadedFile.new(picture2_path) }

  context "認可されたユーザーの場合" do
    it "レスポンスが正常に表示されること(+フレンドリーフォワーディング)" do
      get edit_book_path(book)
      login_for_request(user)
      expect(response).to redirect_to edit_book_url(book)
      patch book_path(book), params: { book: { name: "座右の銘",
                                               thoughts: "いろいろな人の考えが載っていて、とても勉強になりました",
                                               picture: picture2 } }
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

  context "別アカウントのユーザーの場合" do
    it "ホーム画面にリダイレクトすること" do
      # 編集
      login_for_request(other_user)
      get edit_book_path(book)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      # 更新
      patch book_path(book), params: { book: { name: "座右の銘",
                                               description: "いろいろな人の考えが載っていて、とても勉強になります" } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end
