# Main service
class MoteefeService < ApplicationService
  def initialize(*args)
    @args = args
    @order_data = {
      delivery_date: Date.today,
      shipments: []
    }
  end

  def call
    @args.empty? ? blank_result : proceed
  end

  def proceed
    single_or_multiple_item_order
    return @order_data
  end

  private

  def single_or_multiple_item_order
    if @args.length == 1
      process_single_item_order
    else
      process_multiple_item_order
    end
  end

  def process_single_item_order
    item = @args[0].keys[0]
    qty = @args[0].values[0]
    suppliers = SupplierStock.where('product_name=? AND in_stock >= ?', item, qty)

    unless suppliers.empty?
      final_supplier = suppliers.sort_by{ |supplier| supplier.delivery_times["uk"] }.first
      delivery_date =  Date.today + final_supplier.delivery_times["uk"].days
      @order_data = {
        delivery_date: delivery_date,
        shipments: [
          {
            supplier: final_supplier.supplier,
            delivery_date: delivery_date,
            items: [
              {
                title: item, count: qty
              }
            ]
          }
        ]
      }
    else
      all_partial_suppliers     = SupplierStock.where('product_name=? AND in_stock >= 1', item)
      sorted_partial_suppliers  = all_partial_suppliers.sort_by{ |supplier| supplier.delivery_times["uk"] }
      first_partial_supplier    = sorted_partial_suppliers.first
      rest_of_qty               = qty - first_partial_supplier.in_stock
      next_partial_supplier     = sorted_partial_suppliers.second
      qty_fulfilled             =  (rest_of_qty - next_partial_supplier.in_stock) <= 0 ? true : false

      if qty_fulfilled
        @order_data = {
          delivery_date: Date.today + next_partial_supplier.delivery_times["uk"].days,
          shipments: [
            {
              supplier: first_partial_supplier.supplier,
              delivery_date: Date.today + first_partial_supplier.delivery_times["uk"].days,
              items: [
                {
                  title: item, count: first_partial_supplier.in_stock
                }
              ]
            },
            {
              supplier: next_partial_supplier.supplier,
              delivery_date: Date.today + next_partial_supplier.delivery_times["uk"].days,
              items: [
                {
                  title: item, count: rest_of_qty
                }
              ]
            }
          ]
        }
      else
        @order_data =  'I CAN NOT COMBINE FROM MORE THAN 2 SUPPLIERS YET'
      end
    end

  end

  def process_multiple_item_order
    suppliers_for_comparison = []

    @args.each do |order_line|
      item = order_line.keys[0]
      qty = order_line.values[0]
      suppliers_for_comparison << SupplierStock.where('product_name=? AND in_stock >= ?', item, qty).map(&:supplier)
    end

    unless suppliers_for_comparison.length > 2
      final_supplier_name = (suppliers_for_comparison.first & suppliers_for_comparison.last)[0]
      @args.each do |order_line|
        item = order_line.keys[0]
        qty = order_line.values[0]
        order = SupplierStock.where('supplier=? AND product_name=?', final_supplier_name, item)[0]
        delivery_date = Date.today + order.delivery_times["uk"].days
        @order_data[:shipments] << { supplier: order.supplier, items: [{ title: order.product_name, count: qty }] }
        @order_data[:delivery_date] = delivery_date if @order_data[:delivery_date] < delivery_date
      end
    else
      @order_data = 'I CAN NOT BUY MORE THAN 3 DIFFERENT ITEMS FROM SINGLE SUPPLIER YET'
    end
  end


  def blank_result
    @order_data = {
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
  end
end
