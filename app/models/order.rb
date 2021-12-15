class Order < ApplicationRecord
  belongs_to :gig
  belongs_to :seller
  belongs_to :buyer
end
