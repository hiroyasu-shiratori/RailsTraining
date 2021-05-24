# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe '`タスクの一覧`のテスト' do
    before do
      # 確認用のタスクを作成
      Task.create(title: '一覧テスト1')
      Task.create(title: '一覧テスト2')
      # タスクの一覧へ遷移
      visit root_path
    end

    it 'ページタイトルの確認' do
      expect(page).to have_title 'タスクの一覧'
    end

    it '全てのタスクが表示されるか確認' do
      expect(page).to have_content '一覧テスト1'
      expect(page).to have_content '一覧テスト2'
    end

    it 'タスクの新規登録へ遷移するか確認' do
      # タスクの新規登録へ遷移する
      click_button 'new_button'
      # 遷移後のpathを確認
      expect(page).to have_current_path new_task_path
    end
  end

  describe '`タスクの新規登録`のテスト' do
    before do
      # タスクの一覧へ遷移
      visit new_task_path
    end

    it 'ページタイトルの確認' do
      expect(page).to have_title 'タスクの新規登録'
    end

    it 'タスクが登録できるか確認' do
      # フォームに値を入れる
      fill_in 'form_title', with: '新規登録テスト'
      fill_in 'form_description', with: 'タスクの新規登録テスト'
      find('#form_status').find("option[value='進行中']").select_option
      find('#form_priority').find("option[value='高']").select_option
      fill_in 'form_deadline', with: '002023-01-01-17-28'
      # タスクの登録ボタン
      click_button 'form_submit'
      # 遷移後のpathを確認
      expect(page).to have_current_path root_path
      # flashのメッセージを確認
      expect(page).to have_selector '.notice', text: '新しいタスクを作成しました'
      # 値が追加されているか確認
      expect(page).to have_content '新規登録テスト'
      expect(page).to have_content '進行中'
      expect(page).to have_content '高'
      expect(page).to have_content '2023-01-01 17:28:00 UTC'
    end

    it '入力必須の確認' do
      # タスクの登録ボタン
      click_button 'form_submit'
      # ページが遷移していない事を確認
      expect(page).to have_current_path new_task_path
    end
  end

  describe '`タスクの詳細`のテスト' do
    let :task do
      # 確認用のタスクを作成
      Task.create(title: '詳細テスト', description: 'タスクの詳細テスト')
    end

    before do
      # タスクの詳細へ遷移
      visit task_path(task.id)
    end

    it 'ページタイトルの確認' do
      expect(page).to have_title 'タスクの詳細'
    end

    it 'タスクの詳細が表示されるか確認' do
      expect(page).to have_content '詳細テスト'
      expect(page).to have_content 'タスクの詳細テスト'
    end

    it 'タスクの詳細へ遷移するか確認' do
      # タスクの新規登録へ遷移する
      click_button 'edit_button'
      # 遷移後のpathを確認
      expect(page).to have_current_path edit_task_path(task.id)
    end
  end

  describe '`タスクの編集`のテスト' do
    let :task do
      # 確認用のタスクを作成
      Task.create(title: '編集テスト')
    end

    before do
      # タスクの編集へ遷移
      visit edit_task_path(task.id)
    end

    it 'ページタイトルの確認' do
      expect(page).to have_title 'タスクの編集'
    end

    it 'タスクが編集できるか確認' do
      # フォームに値を入れる
      fill_in 'form_title', with: '編集後のタスク'
      # タスクの編集ボタン
      click_button 'form_submit'
      # 遷移後のpathを確認
      expect(page).to have_current_path task_path(task.id)
      # flashのメッセージを確認
      expect(page).to have_selector '.notice', text: 'タスクを更新しました'
      # 値が編集されているか確認
      expect(page).to have_content '編集後のタスク'
    end
  end

  describe '`タスクの削除`のテスト' do
    let :task do
      # 確認用のタスクを作成
      Task.create(title: '削除テスト')
    end

    before do
      # タスクの詳細へ遷移
      visit task_path(task.id)
    end

    it 'タスクが削除できるか確認' do
      # タスクの削除でokを押す
      page.accept_confirm do
        click_button 'delete_button'
      end
      # 遷移後のpathを確認
      expect(page).to have_current_path root_path
      # flashのメッセージを確認
      expect(page).to have_selector '.notice', text: 'タスクを削除しました'
    end

    it 'タスクの削除をキャンセルできるか確認' do
      # タスクの削除でキャンセルを押す
      page.dismiss_confirm do
        click_button 'delete_button'
      end
      # ページが遷移していない事を確認
      expect(page).to have_current_path task_path(task.id)
    end
  end
end
