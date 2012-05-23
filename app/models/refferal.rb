class Refferal < ActiveRecord::Base
  belongs_to :from_user, class_name: "User"
  belongs_to :to_user,   class_name: "User"
  validate :not_reffered_by_self
  def not_reffered_by_self
    if from_user != to_user
       errors.add(:from_user, "You cannot reffer yourself")
    end
  end
end
