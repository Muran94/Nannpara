module CapybaraMacros
  # Semantic UI の dropdownのシミュレートを補助するためのメソッド
  def select_from_dropdown(dropdown_selector, item_text)
    dropdown = find(dropdown_selector)
    dropdown.click
    dropdown.find('.menu .item', text: item_text).click
  end

  def selected_value_from_dropdown(dropdown_selector, selected_value)
    dropdown = find(dropdown_selector)
    expect(dropdown).to have_content selected_value
  end
end
