class Task < ApplicationRecord
  before_validation :set_nameless_name

  validates :name,
            presence: true,
            length: { maximum: 30 },
            uniqueness: true
  validate :validate_name_not_including_comma

  belongs_to :user

  has_one_attached :image

  scope :recent, -> { order(created_at: :desc) }

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[name created_at]
    end

    def ransackable_associations(auth_object = nil)
      []
    end
  end

  private

  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
