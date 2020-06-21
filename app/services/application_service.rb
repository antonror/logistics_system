class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def initialize(*)
    raise NotImplementedError
  end

  def call
    raise NotImplementedError
  end
end
