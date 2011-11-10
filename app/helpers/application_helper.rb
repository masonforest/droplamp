module ApplicationHelper
  def current_user_first_name
    current_user#["name"].to_s.split(' ')[0]
  end
  def twitterized_flash_type(type)
  case type
    when :alert
      "warning"
    when :error
      "error"
    when :notice
      "info"
    when :success
      "success"
    else
      type.to_s
  end
end
  
end
