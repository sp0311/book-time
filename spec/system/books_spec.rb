require 'rails_helper'

RSpec.describe "Book es", type: :system do
  let!(:user) { create(:user) }
  let!(:book) { create(:book, user: user) }

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
        fill_in "感想", with: "いろいろな人の考えが載っていて、とても勉強になりました"
        click_button "登録する"
        expect(page).to have_content "本が登録されました！"
      end

      it "無効な情報で本登録を行うと本登録失敗のフラッシュが表示されること" do
        fill_in "本のタイトル/著者名", with: ""
        fill_in "感想", with: "いろいろな人の考えが載っていて、とても勉強になりました"
        click_button "登録する"
        expect(page).to have_content "本のタイトル/著者名を入力してください"
      end
    end
  end

  describe "本の編集ページ" do
    before do
      login_for_system(user)
      visit book_path(book)
      click_link "編集"
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('本の情報編集')
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content '本のタイトル/著者名'
        expect(page).to have_content '感想'
      end
    end

    context "本の更新処理" do
      it "有効な更新" do
        fill_in "本のタイトル/著者名", with: "編集：座右の銘"
        fill_in "感想", with: "編集：いろいろな人の考えが載っていて、とても勉強になりました"
        click_button "更新する"
        expect(page).to have_content "本の情報が更新されました！"
        expect(book.reload.name).to eq "編集：座右の銘"
        expect(book.reload.thoughts).to eq "編集：いろいろな人の考えが載っていて、とても勉強になりました"
      end

      it "無効な更新" do
        fill_in "本のタイトル/著者名", with: ""
        click_button "更新する"
        expect(page).to have_content '本のタイトル/著者名を入力してください'
        expect(book.reload.name).not_to eq ""
      end
    end

    context "本の削除処理", js: true do
      it "削除成功のフラッシュが表示されること" do
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '本が削除されました'
      end
    end
  end

  describe "本の詳細ページ" do
    context "ページレイアウト" do
      before do
        login_for_system(user)
        visit book_path(book)
      end

      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("#{book.name}")
      end

      it "本情報が表示されること" do
        expect(page).to have_content book.name
        expect(page).to have_content book.thoughts
      end
    end

    context "本の削除", js: true do
      it "削除成功のフラッシュが表示されること" do
        login_for_system(user)
        visit book_path(book)
        within find('.change-book') do
          click_on '削除'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '本が削除されました'
      end
    end
  end
end
