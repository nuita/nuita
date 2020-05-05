class CensoringsController < ApplicationController
  include TagsHelper

  before_action :authenticate_user!

  def update
    begin
      visible_tags.each do |tag_name|
        if current_user.censoring?(tag_name)
          current_user.uncensor(tag_name) if params[tag_name] == '0'
        else
          current_user.censor(tag_name) if params[tag_name] == '1'
        end
      end
      flash[:success] = '検閲カテゴリの設定に成功しました'
    rescue => e
      flash[:danger] = "検閲カテゴリの設定に失敗しました: #{e}"
    ensure
      redirect_to edit_user_registration_path(current_user)
    end
  end
end
