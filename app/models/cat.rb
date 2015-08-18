require 'byebug'
class Cat < ActiveRecord::Base
  COLORS = ["black", "white", "brown", "orange"]

  validates :birthdate, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: { in: COLORS, message: "#{:color} is not a valid color" }
  validates :sex, inclusion: { in: %w(F M), message: "#{:sex} must be either M or F" }

  has_many :rental_requests, :dependent => :destroy,
    class_name: 'CatRentalRequest',
    foreign_key: :cat_id,
    primary_key: :id
end
