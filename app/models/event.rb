class Event < ActiveRecord::Base
  belongs_to :creator, class_name: User
  has_many :attendances
  has_many :friends, through: :attendances

  before_validation :fill_invite_from, unless: :invite_from
  before_validation :fill_invite_to, unless: :invite_to
  validates :name, :start_at, :minutes_for_answer, presence: true
  validates :attendees_min_count, :attendees_max_count, presence: true
  validate :attendances_is_correct
  validate :timeline_is_correct, if: :start_at

  def attendees_count
    0
  end

  private

  def fill_invite_from
    self.invite_from = DateTime.now
  end

  def fill_invite_to
    self.invite_to = start_at
  end

  def timeline_is_correct
    errors.add(:base, :invalid_dates_order) if invite_from >= invite_to or invite_to > start_at
  end

  def attendances_is_correct
    errors.add(:base, 'Wrong numbers of attendances') if self.attendees_max_count < self.attendees_min_count or self.attendees_max_count <=0 or self.attendees_min_count <= 0
  end

end
