module ApplicationHelper
  def current_user_first_name
    current_user#["name"].to_s.split(' ')[0]
  end
end
