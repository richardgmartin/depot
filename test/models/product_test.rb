require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product is not valid without a unique title"  do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          price: 1,
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product attributes must not be empty"  do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive - 1"  do
    product = Product.new(title: "book 1", description: "book 1 description", image_url: "zzz-1.jpg")
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
  end

  test "product price must be positive - 2"  do
    product = Product.new(title: "book 2", description: "book 2 description", image_url: "zzz-2.jpg")
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
  end

  test "product price must be positive - 3"  do
    product = Product.new(title: "book 3", description: "book 3 description", image_url: "zzz-3.jpg")
    product.price = 1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
  end

  def new_product(image_url)
    Product.new(title: "My Book Title", description: "xxx", price: 1, image_url: image_url)
  end

  test "image_url"  do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end

  end

end
