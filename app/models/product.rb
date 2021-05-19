class Product < ApplicationRecord
    belongs_to :category
    belongs_to :brand
    belongs_to :store
    has_one_attached :image, dependent: :destroy
    has_and_belongs_to_many :orders

    has_one_attached :image
    has_many :order_products
    has_many :orders, through: :order_products
    
    def self.search(search)
        if search
            products = self.where("lower(title) LIKE lower(?) or lower(description) LIKE(?)", "%#{search}%", "%#{search}%")
            if products.exists?
                products
            else
                @products = []
            end
        else
            @products = self.all
        end
    end
end