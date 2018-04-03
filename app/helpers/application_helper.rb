module ApplicationHelper
    # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = "NANBARA | ナンパ師のSNS・仲間募集掲示板"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def activate_tab_if_correct_page(action_name)
    'active' if controller.action_name == action_name
  end
end
