class Micropost < ApplicationRecord
  # relation macro
  belongs_to :user
  has_one_attached :image

  # validate
  validates :content, presence: true,
    length: {maximum: Settings.content_max_length}
  validates :image, content_type: {
    in: Settings.image_type,
    message: I18n.t("error.valid.image.format")
  },
    size: {
      less_than: Settings.image_size.megabytes,
      message:
        I18n.t("error.valid.image.size", size: Settings.image_size.megabytes)
    }

  # scopes
  scope :sort_by_created_at, ->{order created_at: :desc}

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
