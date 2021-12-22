class Gig < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :pricings
  has_rich_text :description
  has_many_attached :photos
  has_many :reviews

  has_many :orders

  accepts_nested_attributes_for :pricings
  
  validates :title, presence: { message: "title can't be blank" }

  def average_rating
    reviews.count == 0? 0 : reviews.average(:stars).round(1)
  end
end
