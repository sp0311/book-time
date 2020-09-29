require 'rails_helper'

RSpec.describe "Books", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:book) { create(:book, :picture, user: user) }
  let!(:comment) { create(:comment, user_id: user.id, book: book) }

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
        attach_file "book[picture]", "#{Rails.root}/spec/fixtures/test_book.jpg"
        click_button "登録する"
        expect(page).to have_content "本が登録されました！"
      end

      it "画像無しで登録すると、デフォルト画像が割り当てられること" do
        fill_in "本のタイトル/著者名", with: "座右の銘"
        click_button "登録する"
        expect(page).to have_link(href: book_path(Book.first))
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
        attach_file "book[picture]", "#{Rails.root}/spec/fixtures/test_book2.jpg"
        click_button "更新する"
        expect(book.reload.picture.url).to include "test_book2.jpg"
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
        expect(page).to have_link nil, href: book_path(book), class: 'book-picture'
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

    context "コメントの登録＆削除" do
      it "自分の本の感想に対するコメントの登録＆削除が正常に完了すること" do
        login_for_system(user)
        visit book_path(book)
        fill_in "comment_content", with: "すごくおもしろかった"
        click_button "コメント"
        within find("#comment-#{Comment.last.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: 'すごくおもしろかった'
        end
        expect(page).to have_content "コメントを追加しました！"
        click_link "削除", href: comment_path(Comment.last)
        expect(page).not_to have_selector 'span', text: 'すごくおもしろかった'
        expect(page).to have_content "コメントを削除しました"
      end

      it "別ユーザーの本のコメントには削除リンクが無いこと" do
        login_for_system(other_user)
        visit book_path(book)
        within find("#comment-#{comment.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: comment.content
          expect(page).not_to have_link '削除', href: book_path(book)
        end
      end
    end
  
    context "検索機能" do
      context "ログインしている場合" do
        before do
          login_for_system(user)
          visit root_path
        end
  
        it "ログイン後の各ページに検索窓が表示されていること" do
          expect(page).to have_css 'form#book_search'
          visit about_path
          expect(page).to have_css 'form#book_search'
          visit use_of_terms_path
          expect(page).to have_css 'form#book_search'
          visit users_path
          expect(page).to have_css 'form#book_search'
          visit user_path(user)
          expect(page).to have_css 'form#book_search'
          visit edit_user_path(user)
          expect(page).to have_css 'form#book_search'
          visit following_user_path(user)
          expect(page).to have_css 'form#book_search'
          visit followers_user_path(user)
          expect(page).to have_css 'form#book_search'
          visit books_path
          expect(page).to have_css 'form#book_search'
          visit book_path(book)
          expect(page).to have_css 'form#book_search'
          visit new_book_path
          expect(page).to have_css 'form#book_search'
          visit edit_book_path(book)
          expect(page).to have_css 'form#book_search'
        end
  
        it "フィードの中から検索ワードに該当する結果が表示されること" do
          create(:book, name: 'ハリーポッターと賢者の石', user: user)
          create(:book, name: 'ハリーポッターと秘密の部屋', user: other_user)
          create(:book, name: '剣客商売三 陽炎の男', user: user)
          create(:book, name: '剣客商売二 辻斬り', user: other_user)
  
          # 誰もフォローしない場合
          fill_in 'q_name_cont', with: 'ハリー'
          click_button '検索'
          expect(page).to have_css 'h3', text: "ハリー”の検索結果：2件"
          within find('.books') do
            expect(page).to have_css 'li', count: 2
          end
          fill_in 'q_name_cont', with: '剣客'
          click_button '検索'
          expect(page).to have_css 'h3', text: "剣客”の検索結果：2件"
          within find('.books') do
            expect(page).to have_css 'li', count: 2
          end
  
          # other_userをフォローする場合
          user.follow(other_user)
          fill_in 'q_name_cont', with: 'ハリー'
          click_button '検索'
          expect(page).to have_css 'h3', text: "ハリー”の検索結果：2件"
          within find('.books') do
            expect(page).to have_css 'li', count: 2
          end
          fill_in 'q_name_cont', with: '剣客'
          click_button '検索'
          expect(page).to have_css 'h3', text: "剣客”の検索結果：2件"
          within find('.books') do
            expect(page).to have_css 'li', count: 2
          end
        end
  
        it "検索ワードを入れずに検索ボタンを押した場合、本一覧が表示されること" do
          fill_in 'q_name_cont', with: ''
          click_button '検索'
          expect(page).to have_css 'h3', text: "本一覧"
          within find('.books') do
            expect(page).to have_css 'li', count: Book.count
          end
        end
      end
  
      context "ログインしていない場合" do
        it "検索窓が表示されないこと" do
          visit root_path
          expect(page).not_to have_css 'form#book_search'
        end
      end
    end
  end
end
