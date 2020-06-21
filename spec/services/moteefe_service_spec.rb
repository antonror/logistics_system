require 'rails_helper'

RSpec.describe MoteefeService do

  before :each do
    create(:supplier_stock, supplier: 'SupplierA', product_name: 't-shirt', delivery_times: { uk: 3, us: 8 }, in_stock: 6 )
    create(:supplier_stock, supplier: 'SupplierB', product_name: 't-shirt', delivery_times: { uk: 1, us: 8 }, in_stock: 7 )
    create(:supplier_stock, supplier: 'SupplierB', product_name: 'hoodie', delivery_times: { uk: 3, us: 8 }, in_stock: 4 )
    create(:supplier_stock, supplier: 'SupplierC', product_name: 'hoodie', delivery_times: { uk: 5, us: 8 }, in_stock: 7 )
  end

  describe 'class hierarchy' do
    context 'should inherit from ApplicationService' do
      it 'should be an instance of ApplicationService' do
        expect(described_class).to be < ApplicationService
      end
    end
  end

  describe 'output generation' do
    context 'with no argument' do
      it 'should provide output without given arguments' do
        output = {
          delivery_date: '',
          shipments: {
            supplier: '',
            delivery_date: '',
            items: [
              {
                  title: '',
                  count: 0
              }
            ]
          }
        }

        result = MoteefeService.new().call

        expect(result).to eq(output)
      end
    end

    context 'with valid arguments' do

      # 7 t-shirts in stock as a maximum from 1 supplier
      # we take 8 to satisfy condition 1
      it 'should provide valid result for scenario 1' do
        result = MoteefeService.new({ 't-shirt' => 8 }).call
        expect(result[:delivery_date]).to eq(Date.today + 3.days)
        expect(result[:shipments].count).to eq(2)
        expect(result[:shipments][0][:items][0][:count]).to eq(7)
        expect(result[:shipments][1][:items][0][:count]).to eq(1)
      end

      # We select the fastest supplier having requested amount
      it 'should provide valid result for scenario 2' do
        result = MoteefeService.new({ 't-shirt' => 5 }).call
        expect(result[:delivery_date]).to eq(Date.today + 1.days)
        expect(result[:shipments].count).to eq(1)
        expect(result[:shipments][0][:items][0][:count]).to eq(5)
      end

      # We select single supplier with requested goods
      # for multi-line order
      it 'should provide valid result for scenario 3' do
        result = MoteefeService.new({ 't-shirt' => 1 }, {'hoodie' => 1}).call
        expect(result[:delivery_date]).to eq(Date.today + 3.days)
        expect(result[:shipments].count).to eq(2)
        expect(result[:shipments][0][:items][0][:title]).to eq('t-shirt')
        expect(result[:shipments][1][:items][0][:title]).to eq('hoodie')
      end
    end
  end
end
