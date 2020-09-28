require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:book) { create(:book) }
  let!(:comment) { create(:comment, user_id: user.id, book: book) }

  context "コメントの登録" do
    context "ログインしている場合" do
      before do
        login_for_request(user)
      end

    it "有効な内容のコメントが登録できること" do
      expect {
        post comments_path, params: { book_id: book.id,
                                      comment: { content: "素敵な本でした！" } }
      }.to change(book.comments, :count).by(1)
    end

    it "無効な内容のコメントが登録できないこと" do
      expect {
        post comments_path, params: { book_id: book.id,
                                      comment: { content: "" } }
      }.not_to change(book.comments, :count)
    end
    end

    context "ログインしていない場合" do
      it "コメントは登録できず、ログインページへリダイレクトすること" do
        expect {
          post comments_path, params: { book_id: book.id,
                                        comment: { content: "素敵な本でした！" } }
        }.not_to change(book.comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "コメントの削除" do
    context "ログインしている場合" do
      context "コメントを作成したユーザーである場合" do
        it "コメントの削除ができること" do
          login_for_request(user)
          expect {
            delete comment_path(comment)
          }.to change(book.comments, :count).by(-1)
        end
      end

      context "コメントを作成したユーザーでない場合" do
        it "コメントの削除はできないこと" do
          login_for_request(other_user)
            expect {
             delete comment_path(comment)
            }.not_to change(book.comments, :count)
        end
      end
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
