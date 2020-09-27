require 'rails_helper'

RSpec.describe "Book es", type: :system do
  let!(:user) { create(:user) }

  describe "本の登録ページ" do
    before do
      login_for_system(user)
      visit new_book_path
    end

    context "ページレイアウト" do
      it "「本の登録」の文字列が存在すること" do
        expect(page).to have_content '本の登録'
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('本の登録')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content '本のタイトル/著者名'
        expect(page).to have_content '感想'
      end
    end

    context "本の登録処理" do
      it "有効な情報で本の登録を行うと本の登録成功のフラッシュが表示されること" do
        fill_in "本のタイトル/著者名", with: "座右の銘"
        fill_in "感想", with: "いろいろな人の考えが載っていて、とても勉強になります"
        click_button "登録する"
        expect(page).to have_content "本が登録されました！"
      end

      it "無効な情報で本登録を行うと本登録失敗のフラッシュが表示されること" do
        fill_in "本のタイトル/著者名", with: ""
        fill_in "感想", with: "いろいろな人の考えが載っていて、とても勉強になります"
        click_button "登録する"
        expect(page).to have_content "本のタイトル/著者名を入力してください"
      end
    end
  end
end