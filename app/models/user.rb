class User < ApplicationRecord
  validates :username, presence: true,
                       format: { with: /\A[A-Za-z0-9]+\z/, message: "must only contain letters and numbers" },
                       uniqueness: true
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" },
                    uniqueness: true
  validates :password, length: { minimum: 6, message: "must be at least 6 characters long" },
                       format: { with: /\d/, message: "must include at least one number" }
  validates :first_name, presence: true
  validates :last_name, presence: true
  before_validation :default_flag_to_true

  def default_flag_to_true
    self.flag = true
  end
end
