class Friendship < ApplicationRecord
  belongs_to :member
  belongs_to :friend, class_name: 'Member'

  validates :member_id, uniqueness: { scope: :friend_id }
  validate :not_self

  after_create :create_inverse, unless: :inverse?
  after_destroy :destroy_inverse, if: :inverse?

  def inverse
    self.class.find_by(inverse_friendship_options)
  end

  private

  def not_self
    errors.add(:friend, "can't be equal to member") if member == friend
  end

  def create_inverse
    self.class.create(inverse_friendship_options)
  end

  def destroy_inverse
    inverse.destroy
  end

  def inverse?
    self.class.exists?(inverse_friendship_options)
  end

  def inverse_friendship_options
    { friend_id: member_id, member_id: friend_id }
  end
end
