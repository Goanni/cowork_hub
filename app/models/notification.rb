class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :booking, optional: true

  validates :message, presence: true
end