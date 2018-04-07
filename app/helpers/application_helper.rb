module ApplicationHelper
  # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = 'NANBARA | ナンパ師のSNS・仲間募集掲示板'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def activate_tab(tab_controller_name)
    if controller_name == tab_controller_name
      "active"
    end
  end

  def activate_tab_for_account_page(tab_action_name)
    if controller.action_name == tab_action_name
      "active"
    end
  end
end
