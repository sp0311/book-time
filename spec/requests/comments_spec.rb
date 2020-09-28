require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:book) { create(:book) }
  let!(:comment) { create(:comment, user_id: user.id, book: book) }

  context "コメントの登録" do
    context "ログインしている場合" do
    end

    context "ログインしていない場合" do
      it "コメントは登録できず、ログインページへリダイレクトすること" do
        expect {
          post comments_path, params: { book_id: book.id,
                                        comment: { content: "おもしろかったです！" } }
        }.not_to change(book.comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "コメントの削除" do
    context "ログインしている場合" do
    end

    context "ログインしていない場合" do
      it "コメントの削除はできず、ログインページへリダイレクトすること" do
        expect {
          delete comment_path(comment)
        }.not_to change(book.comments, :count)
      end
    end
  end
end
