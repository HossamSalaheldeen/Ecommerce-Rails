class Product < ApplicationRecord
    belongs_to :category
    belongs_to :brand
    belongs_to :store
    has_one_attached :image, dependent: :destroy
    has_and_belongs_to_many :orders
    has_many :rates
    has_many :order_products
    has_many :reviews
    has_many :wishlists
    has_many :orders, through: :order_products
    validates :title, presence: true
    validates :price, :quantity, numericality: true
    validates :description, :price, :quantity, :category_id, :brand_id, presence: true
    
    def self.search(search)
        if search.nil? || search.empty? 
            @products = self.all  
        else
            products = self.where("lower(title) LIKE lower(?) or lower(description) LIKE(?)", "%#{search}%", "%#{search}%")

            if products.exists?
                products
            else
                @products = []
            end
        end
    end

    def self.filter(filter, filterby)
        if filterby === "category"
            category = Category.find_by(name: filter)
            if category
                products = self.where(category_id: category.id)
            end
        elsif filterby === "brand"
            brand = Brand.find_by(name: filter)
            if brand
                products = self.where(brand_id: brand.id)
            end
        elsif filterby === "store"
            store = Store.find_by(name: filter)
            if store
                products = self.where(store_id: store.id)
            end
        end
    end

    def self.filter_by_price(filter1, filter2)
        products = self.where('price Between ? AND ?', filter1, filter2)
    end

    def check_order(prod, id)
        @orders = Order.where(user_id: id, state: "delivered")
        if !@orders.empty?
            @orders.each do |order|
                if !(order.order_products).where(product_id: prod.id).empty?
                    return true
                end
            end
        end
        return false
    end

end