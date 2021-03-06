# frozen_string_literal: true

class Event < ApplicationRecord
  resourcify

  # scope
  scope :running, -> { where('start < :now and over > :now', now: Time.now) }
  scope :sign_up_expired, -> { where('sign_up_end < :now', now: Time.now) }
  scope :in_registration_time, -> { where('sign_up_end >= :now and sign_up_begin <= :now', now: Time.now) }
  scope :closed, -> { where('over < :now', now: Time.now) }
  scope :start_after_days, lambda { |number|
    days = Time.now + number.days
    where('start >= :t1 and start < :t2', t1: days, t2: (days + 1.days))
  }

  # relation
  belongs_to :organizer, class_name: 'User', foreign_key: :user_id
  has_many :event_users, dependent: :destroy
  has_many :participants, through: :event_users, source: :user

  # valid
  validates_presence_of :name, :max_sign_up_number, :sign_up_begin, :sign_up_end, :start, :over
  validates_numericality_of :registery_fee, allow_nil: true
  validate :time_validations

  # instance method
  def full?
    participants_count >= max_sign_up_number
  end

  def on_registration?
    now = Time.now.to_i
    sign_up_begin.to_i <= now && now <= sign_up_end.to_i
  end

  def show_participants_count
    show_participants ? participants_count : '?'
  end

  def opening_notice
    participants.each do |user|
      next unless user.subscription.joined_events?

      # Email
      EventMailer.opening_notice(self, user).deliver_now
      # Facebook Messenger
      # TODO: send notice through Facebook Messenger
    end
  end

  private

  def time_validations
    if max_sign_up_number.to_i < min_sign_up_number.to_i
      errors[:max_sign_up_number] << '報名活動的人數上限要比活動成立的人數高吧!'
    end
    if sign_up_begin.to_i >= sign_up_end.to_i
      errors[:sign_up_end] << '結束報名的時間要比開始報名的時間後面喔!'
    end
    errors[:start] << '活動開始的時間要比活動結束的時間還前面吧!' if start.to_i >= over.to_i
    errors[:over] << '報名截止的時間要在活動結束的時間之前喔!' if sign_up_end.to_i >= over.to_i
  end
end
