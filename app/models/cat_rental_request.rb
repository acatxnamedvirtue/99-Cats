require 'byebug'
class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :user_id, presence: true
  validate :no_overlapping_approved_requests
  after_initialize :set_status
  validates :status, inclusion: { in: %w(PENDING DENIED APPROVED),
    message: "#{:status} must be PENDING, APPROVED, or DENIED." }


  belongs_to :cat,
    class_name: 'Cat',
    foreign_key: :cat_id,
    primary_key: :id

  belongs_to :requester,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id

  def pending?
    status == "PENDING"
  end


  def approve!
    self.class.transaction do
      overlapping_pending_requests.each do |request|
        request.deny!
      end
      update!(status: "APPROVED")
    end
  end

  def deny!
    update!(status: "DENIED")
  end

  private
  def overlapping_requests
    CatRentalRequest
      .where("cat_id = ?", cat_id)
      .where("? > cat_rental_requests.start_date AND ? < cat_rental_requests.end_date", end_date, start_date)
      .where("? IS NULL OR cat_rental_requests.id != ?", id, id)
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: "PENDING")
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def no_overlapping_approved_requests
    unless overlapping_approved_requests.empty?
      errors.add(:date_range, "cannot overlapping existing approved requests")
    end
  end

  def set_status
    self.status ||= "PENDING"
  end
end
