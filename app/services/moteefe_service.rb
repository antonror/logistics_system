# Main service
class MoteefeService < ApplicationService
  def initialize(*args)
    @args = args

  end

  def call
    @args.empty? ? blank_result : proceed
  end

  def proceed

  end

  private

  def blank_result
    {
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
  end
end
