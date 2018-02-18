require 'csv'
require 'awesome_print'
require_relative 'order.rb'
require_relative 'customer.rb'

ONLINE_FILE_NAME = 'support/online_orders.csv'


module  Grocery

  class OnlineOrder < Order
    attr_reader :customer_id, :status

    def initialize(id, products, customer_id, status)
      super(id, products)
      # @id = id
      # @products = products
      @customer_id = customer_id
      @status = status.to_sym
    end


    def total
      if @products.length > 0
        return (super()+10).round(2)
      else
        return 0
      end
    end

    def add_product(name, price)
      if [:pending, :paid].include?(@status)
        super(name,price)
      end
    end

    def self.all
      all_orders = []
      CSV.open(ONLINE_FILE_NAME, 'r').each do |str|
        new_hash = {}
        id = str[0].to_i
        customer_id = str[2].to_i
        status = str[3]

        str[1].split(";").each do |pair|
          new_pair = pair.split(":")
          key = new_pair[0]
          value = new_pair[1].to_f
          new_hash[key] = value
        end
        new_order = OnlineOrder.new(id, new_hash, customer_id, status)
        all_orders << new_order
      end
      return all_orders
    end

  end
end

new_online_order = Grocery::OnlineOrder.new(434, {"product": 5.50, "apples": 4.50},45,"pending")

puts new_online_order.total

puts new_online_order.products

puts Grocery::Customer.find(new_online_order.customer_id)
