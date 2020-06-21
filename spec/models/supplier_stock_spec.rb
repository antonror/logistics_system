require 'rails_helper'

RSpec.describe SupplierStock, type: :model do
  context 'database structure' do
    it { should have_db_column(:product_name).of_type(:string) }
    it { should have_db_column(:supplier).of_type(:string) }
    it { should have_db_column(:delivery_times).of_type(:json)}
    it { should have_db_column(:in_stock).of_type(:integer) }
  end

  describe 'validations' do
    context 'supplier' do
      it 'validates suppliers name for uniqueness' do
        supplier = 'Awesome Goods INC'
        create(:supplier_stock, supplier: supplier)
        clone = build(:supplier_stock, supplier: supplier)

        expect(clone).not_to be_valid
      end
    end
  end
end