require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'


describe "Order Wave 1" do
  describe "#initialize" do
    it "Takes an ID and collection of products" do
      id = 1337
      order = Grocery::Order.new(id, {})

      order.must_respond_to :id
      order.id.must_equal id
      order.id.must_be_kind_of Integer

      order.must_respond_to :products
      order.products.length.must_equal 0
    end
  end

  describe "#total" do
    it "Returns the total from the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      sum = products.values.inject(0, :+)
      expected_total = sum + (sum * 0.075).round(2)

      order.total.must_equal expected_total
    end

    it "Returns a total of zero if there are no products" do
      order = Grocery::Order.new(1337, {})

      order.total.must_equal 0
    end
  end

  describe "#add_product" do
    it "Increases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Grocery::Order.new(1337, products)

      order.add_product("salad", 4.25)
      expected_count = before_count + 1
      order.products.count.must_equal expected_count
    end

    it "Is added to the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      order.add_product("sandwich", 4.25)
      order.products.include?("sandwich").must_equal true
    end

    it "Returns false if the product is already present" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Grocery::Order.new(1337, products)
      before_total = order.total

      result = order.add_product("banana", 4.25)
      after_total = order.total

      result.must_equal false
      before_total.must_equal after_total
    end

    it "Returns true if the product is new" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      result = order.add_product("salad", 4.25)
      result.must_equal true
    end
  end

  describe "#remove_product" do
    it "Removes a product if the product exists" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)
      result = order.remove_product("cracker")
      order.products.length.must_equal 1
      result.must_equal true
    end

    it "Removes a product if the product exists" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)
      result = order.remove_product("apple")
      order.products.length.must_equal 2
      result.must_equal false

    end
  end

end

describe "Order Wave 2" do
  describe "Order.all" do

    it "Returns an array of all orders" do
      list = Grocery::Order.all
      list.must_be_kind_of Array
      list[0].must_be_kind_of Grocery::Order
    end

    it "Returns accurate information about the first order" do
      list_item = Grocery::Order.all[0]
      expected_products = {'Slivered Almonds'=>22.88, 'Wholewheat flour'=>1.93, 'Grape Seed Oil'=>74.9}
      expected_id = 1
      list_item.products.must_equal expected_products
      list_item.id.must_equal expected_id
    end

    it "Returns accurate information about the last order" do
      list_item = Grocery::Order.all[-1]
      expected_products = {'Allspice'=>64.74, 'Bran'=>14.72,'UnbleachedFlour'=>80.59}
      expected_id = 100
      list_item.products.must_equal expected_products
      list_item.id.must_equal expected_id
    end
  end

  describe "Order.find" do
    it "Can find the first order from the CSV" do
      result = Grocery::Order.find(1)
      result.must_be_kind_of Grocery::Order
      result.id.must_equal 1
    end

    it "Can find the last order from the CSV" do
      result = Grocery::Order.find(100)
      result.must_be_kind_of Grocery::Order
      result.id.must_equal 100
    end

    it "Returns Nil for an order that doesn't exist" do
      result = Grocery::Order.find(180)
      result.must_be_nil
    end
  end
end
