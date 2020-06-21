class SupplierStock < ApplicationRecord
  validates :supplier, uniqueness: true
end
