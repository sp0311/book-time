require 'rails_helper'

RSpec.describe Book, type: :model do
  let!(:book_yesterday) { create(:book, :yesterday) }
  let!(:book_one_week_ago) { create(:book, :one_week_ago) }
  let!(:book_one_month_ago) { create(:book, :one_month_ago) }
  let!(:book) { create(:book) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(book).to be_valid
    end

    it "本のタイトル/著者名がなければ無効な状態であること" do
      book = build(:book, name: nil)
      book.valid?
      expect(book.errors[:name]).to include("を入力してください")
    end

    it "本のタイトル/著者名が50文字以内であること" do
      book = build(:book, name: "あ" * 51)
      book.valid?
      expect(book.errors[:name]).to include("は50文字以内で入力してください")
    end

    it "感想が400文字以内であること" do
      book = build(:book, thoughts: "あ" * 401)
      book.valid?
      expect(book.errors[:thoughts]).to include("は400文字以内で入力してください")
    end

    it "ユーザーIDがなければ無効な状態であること" do
      book = build(:book, user_id: nil)
      book.valid?
      expect(book.errors[:user_id]).to include("を入力してください")
    end

    context "並び順" do
      it "最も最近の投稿が最初の投稿になっていること" do
        expect(book).to eq Book.first
      end
    end
  end
end
