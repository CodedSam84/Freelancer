class Gig < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :pricings
  has_rich_text :description
  has_many_attached :photos

  has_many :orders

  accepts_nested_attributes_for :pricings
  
  validates :title, presence: { message: "title can't be blank" }
end
