module ApplicationHelper
  def emphasize_keyword(text, keyword)
    safe_text = sanitize(text)
    safe_text.gsub(keyword, '<b>' + keyword + '</b>').html_safe
  end
end
