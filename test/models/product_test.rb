require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test 'product attributes must not be empty' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = Product.new(title: 'Test', description: 'desc', image_url: 'url.jpg')

    product.price = -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
                 product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'],
                 product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: 'Test', description: 'desc', image_url:, price: 1)
  end

  test 'image url' do
    ok = %w[charlie.gif charlie.jpg charlie.png CHARLIE.JPG CHARLIE.PNG CHARLIE.GIF http://char/lie/image.jpg]
    bad = %w[charlie.doc charlie.pdf charlie.gif.more]

    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} must be valid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} must be invalid"
    end
  end

  test 'product is not valid w/o a unique title - i18n' do
    product = Product.new(title: products(:elixir).title, description: 'foo', price: 1, image_url: 'charlie.jpg')

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end
