class Friend < ActiveRecord::Base
  belongs_to :user
  belongs_to :creator, class_name: User
  has_many :group_memberships
  has_many :groups, through: :group_memberships
  has_many :attendances
  has_many :events, through: :attendances

  validate :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, allow_blank: true
  validate :phone, format: { with: /\d{3}-\d{3}-\d{4}/, message: "bad format" },allow_blank: true
  validate :has_email_or_phone, allow_blank: true, unless: :user

  def group_names
    groups.map(&:name).to_sentence
  end

  def attendance_percentage
    '50%'
  end

  def current_email
    user.try(:email) || email
  end

  private

  def has_email_or_phone
    if email.blank? and phone.blank?
      errors.add(:base, :empty_phone_and_email)

    end
  end
end
