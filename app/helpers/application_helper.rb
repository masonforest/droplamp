module ApplicationHelper
  include TweetButton
  def current_user_first_name
    current_user#["name"].to_s.split(' ')[0]
  end
  def twitterized_flash_type(type)
  case type
    when :alert
      "alert"
    when :error
      "alert alert-error"
    when :notice
      "alert alert-info"
    when :success
      "alert alert-success"
    else
      type.to_s
  end
end
  
end
