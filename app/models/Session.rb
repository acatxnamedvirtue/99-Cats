class Session < ActiveRecord::Base
  validates :user_id, :session_token, :browser, presence: true
  validates :session_token, uniqueness: true

  belongs_to :user,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
end
