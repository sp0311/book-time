require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "トップページ" do
    context "ページ全体" do
      before do
        visit root_path
      end

      it "BOOK TIMEの文字列が存在することを確認" do
        expect(page).to have_content 'BOOK TIME'
      end

      it "正しいタイトルが表示されることを確認" do
        expect(page).to have_title full_title
      end

      context "本フィード", js: true do
        let!(:user) { create(:user) }
        let!(:book) { create(:book, user: user) }

        before do
          login_for_system(user)
        end

        it "本のぺージネーションが表示されること" do
          login_for_system(user)
          create_list(:book, 6, user: user)
          visit root_path
          expect(page).to have_content "みんなの本 (#{user.books.count})"
          expect(page).to have_css "div.pagination"
          Book.take(5).each do |d|
            expect(page).to have_link d.name
          end
        end

        it "「新しい本を登録」リンクが表示されること" do
          visit root_path
          expect(page).to have_link "新しい本を登録", href: new_book_path
        end

        it "本を削除後、削除成功のフラッシュが表示されること" do
          visit root_path
          click_on '削除'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content '本が削除されました'
        end
      end
    end
  end

  describe "ヘルプページ" do
    before do
      visit about_path
    end

    it "BOOK TIMEとは？の文字列が存在することを確認" do
      expect(page).to have_content 'BOOK TIMEとは？'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('BOOK TIMEとは？')
    end
  end

  describe "利用規約ページ" do
    before do
      visit use_of_terms_path
    end

    it "利用規約の文字列が存在することを確認" do
      expect(page).to have_content '利用規約'
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('利用規約')
    end
  end
end
