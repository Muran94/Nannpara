require 'nokogiri'
require 'capybara'

class RecruitmentLinkageJob < ApplicationJob
  queue_as :default

  # 関東ナンパ友募集掲示板のURL
  KANTO_NANPA_MESSAGEBOARD_URL = "http://realnp.com/bbs/bbs.php".freeze

  def perform(recruitment)
    if recruitment.linked_with_kanto_nanpa_messageboard
      Capybara.default_selector = :xpath
      session = Capybara::Session.new(:selenium_chrome_headless)
      session.visit KANTO_NANPA_MESSAGEBOARD_URL
      session.fill_in "name", with: recruitment.user.name
      session.fill_in "mail", with: recruitment.user.email
      session.fill_in "title", with: recruitment.title
      session.fill_in "body2", with: _build_body(recruitment)
      session.fill_in "deleteKey", with: recruitment.kanto_nanpa_messageboard_delete_key

      session.find("/html/body/form/table/tbody/tr[6]/td[2]/input").click # 投稿ボタンをクリック
      sleep 2
      session.driver.browser.switch_to.alert.accept # confirmダイアログのOKボタンをクリック
    end
  end
  private

    def _build_body(recruitment)
      body = []
      body << %(【年齢】#{recruitment.user.age}\n) if recruitment.user.age.present?
      body << %(【ナンパ歴】#{recruitment.user.experience}\n) if recruitment.user.experience.present?
      body << %(【開催日時】#{recruitment.event_date.strftime("%Y/%m/%d %H時%M分")}\n)
      body << %(【開催場所】#{recruitment.prefecture.name} #{recruitment.venue}\n)
      body << %(【募集内容】#{recruitment.description}\n\n)
      body << %(掲載元 : NANBARA | ナンパ師のSNS・仲間募集掲示板)
      body.join("")
    end
end
