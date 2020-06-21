require 'rails_helper'

RSpec.describe ApplicationService do
  context 'when inherited class does not implement initialize' do
    class DummyClass1 < described_class
    end

    it 'raises NotImplementedError' do
      expect { DummyClass1.call }.to raise_error(NotImplementedError)
    end
  end

  context 'when inherited class does not implement call' do
    class DummyClass2 < described_class
      def initialize(*); end
    end

    it 'raises NotImplementedError' do
      expect { DummyClass2.call }.to raise_error(NotImplementedError)
    end
  end

  context 'when everything ok' do
    class DummyClass3 < described_class
      def initialize(*); end

      def call; end
    end

    it 'passes params correctly' do
      allow(DummyClass3).to receive(:new).and_return(double(call: true))

      DummyClass3.call('param')

      expect(DummyClass3).to have_received(:new).with('param')
    end

    it 'passes block correctly' do
      allow(DummyClass3).to receive(:new).and_return(double(call: true))

      block_stub = 'block stub'

      DummyClass3.call(1) { block_stub }

      expect(DummyClass3).to have_received(:new).with(1) do |*_args, &block|
        expect(block.call).to eq(block_stub)
      end
    end

    it 'calls #call method in descendant classes' do
      dummy_instance = instance_double(DummyClass3, call: true)
      allow(DummyClass3).to receive(:new).and_return(dummy_instance)

      DummyClass3.call

      expect(dummy_instance).to have_received(:call)
    end
  end
end
