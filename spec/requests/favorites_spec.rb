require 'rails_helper'

RSpec.describe "お気に入り機能", type: :request do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  context "お気に入り登録処理" do
    context "ログインしている場合" do
      before do
        login_for_request(user)
      end

      it "本のお気に入り登録ができること" do
        expect {
          post "/favorites/#{book.id}/create"
        }.to change(user.favorites, :count).by(1)
      end

      it "本のAjaxによるお気に入り登録ができること" do
        expect {
          post "/favorites/#{book.id}/create", xhr: true
        }.to change(user.favorites, :count).by(1)
      end

      it "本のお気に入り解除ができること" do
        user.favorite(book)
        expect {
          delete "/favorites/#{book.id}/destroy"
        }.to change(user.favorites, :count).by(-1)
      end

      it "本のAjaxによるお気に入り解除ができること" do
        user.favorite(book)
        expect {
          delete "/favorites/#{book.id}/destroy", xhr: true
        }.to change(user.favorites, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      it "お気に入り登録は実行できず、ログインページへリダイレクトすること" do
        expect {
          post "/favorites/#{book.id}/create"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end

      it "お気に入り解除は実行できず、ログインページへリダイレクトすること" do
        expect {
          delete "/favorites/#{book.id}/destroy"
        }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
