require 'rails_helper'

RSpec.describe SupplierStock, type: :model do
  context 'database structure' do
    it { should have_db_column(:product_name).of_type(:string) }
    it { should have_db_column(:supplier).of_type(:string) }
    it { should have_db_column(:in_stock).of_type(:integer) }
  end
end