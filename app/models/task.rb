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
    def csv_attributes
      %w[name description created_at updated_at]
    end

    def generate_csv
      CSV.generate(headers: true) do |csv|
        csv << csv_attributes
        all.each do |task|
          csv << csv_attributes.map { |attr| task.send(attr) }
        end
      end
    end

    def import(file)
      CSV.foreach(file.path, headers: true) do |row|
        task = new
        task.attributes = row.to_hash.slice(*csv_attributes)
        task.save!
      end
    end

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
