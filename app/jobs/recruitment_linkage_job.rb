require 'capybara'
require 'selenium-webdriver'

class RecruitmentLinkageJob < ApplicationJob
  queue_as :default

  # 関東ナンパ友募集掲示板のURL
  KANTO_NANPA_MESSAGEBOARD_URL = 'http://realnp.com/bbs/bbs.php'.freeze

  def perform(recruitment)
    if recruitment.linked_with_kanto_nanpa_messageboard
      chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
      base_args = %w(headless no-sandbox disable-gpu)
      chrome_opts = chrome_bin ? { 'chromeOptions' => { 'binary' => chrome_bin, 'args' => base_args } } : {}

      Capybara.register_driver :chrome do |app|
        Capybara::Selenium::Driver.new(
          app,
          browser: :chrome,
          desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(chrome_opts)
        )
      end

      Capybara.default_driver = :chrome
      Capybara.default_selector = :xpath
      session = Capybara::Session.new(:chrome)
      session.visit KANTO_NANPA_MESSAGEBOARD_URL
      session.fill_in 'name', with: recruitment.user.name
      session.fill_in 'mail', with: recruitment.user.email
      session.fill_in 'title', with: recruitment.title
      session.fill_in 'body2', with: _build_body(recruitment)
      session.fill_in 'deleteKey', with: recruitment.kanto_nanpa_messageboard_delete_key

      session.find('/html/body/form/table/tbody/tr[6]/td[2]/input').click # 投稿ボタンをクリック
      sleep 2
      session.driver.browser.switch_to.alert.accept # confirmダイアログのOKボタンをクリック
    end
  end

  private

  def _build_body(recruitment)
    body = []
    body << %(【年齢】#{recruitment.user.age}\n) if recruitment.user.age.present?
    body << %(【ナンパ歴】#{recruitment.user.experience}\n) if recruitment.user.experience.present?
    body << %(【開催日】#{recruitment.event_date.strftime('%Y/%m/%d')}\n)
    body << %(【都道府県】#{recruitment.prefecture.name}\n\n)
    body << %(\n#{recruitment.description}\n\n)
    body << %(掲載元 : NANBARA | ナンパ師のSNS・仲間募集掲示板)
    body.join('')
  end
end
