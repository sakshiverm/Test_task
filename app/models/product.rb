class Product < ApplicationRecord
    validates :name, presence: true
    validates :price, numericality: true
    validates :description, presence: true
    belongs_to :category
    has_one_attached :image
    has_many :images, as: :imageable

    # def image_url
    #     Rails.application.routes.url_helpers.url_for(image) if image.attached?
    # end
end
