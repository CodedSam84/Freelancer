class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :request

  validates :amount, :days, numericality: { only_integer: true }
  
  enum status: [:pending, :accepted, :rejected]
end
