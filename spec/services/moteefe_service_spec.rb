require 'rails_helper'

RSpec.describe MoteefeService do

  before :each do
    create(:supplier_stock, supplier: 'SupplierA', product_name: 't-shirt', delivery_times: { uk: 3, us: 8 }, in_stock: 6 )
    create(:supplier_stock, supplier: 'SupplierB', product_name: 't-shirt', delivery_times: { uk: 1, us: 8 }, in_stock: 7 )
    create(:supplier_stock, supplier: 'SupplierB', product_name: 'hoodie1', delivery_times: { uk: 3, us: 8 }, in_stock: 4 )
    create(:supplier_stock, supplier: 'SupplierC', product_name: 'hoodie1', delivery_times: { uk: 5, us: 8 }, in_stock: 7 )
  end

  describe 'class hierarchy' do
    context 'should inherit from ApplicationService' do
      it 'should be an instance of ApplicationService' do
        expect(described_class).to be < ApplicationService
      end
    end
  end

  describe 'output generation'
    context 'with no argument' do
      it 'should provide output without given arguments' do
        output = {
            date: '',
            shipments: {
                supplier: '',
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
end
