class Request < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :offers, dependent: :destroy
  has_one_attached :file

  validates :title, presence: {message: "Title can't be blank"}
  validates :description, presence: {message: "Description can't be blank"}
  validates :delivery, numericality: { only_integer: true }
end
