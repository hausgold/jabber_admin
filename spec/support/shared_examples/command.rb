# frozen_string_literal: true

require 'spec_helper'

shared_examples 'a command' \
  do |with_name:, with_input_args: [], with_called_args: []|
  let(:callable) { proc { true } }

  it 'calls the call method on the given callable' do
    expect(callable).to receive(:call).once
    described_class.call(callable, *with_input_args)
  end

  # rubocop:disable RSpec/MultipleExpectations because of the test abstraction
  # rubocop:disable RSpec/ExampleLength because of the test abstraction
  it "passes '#{with_name}' as command name to the callable" do
    callable = proc do |command, _payload = {}|
      expect(command).to be_eql(with_name)
    end
    expect(callable).to receive(:call).once.and_call_original
    described_class.call(callable, *with_input_args)
  end

  if with_input_args.empty?
    it 'passes no further arguments to the callable' do
      callable = proc do |_command, payload = {}|
        expect(payload).to be_eql({})
      end
      expect(callable).to receive(:call).once.and_call_original
      described_class.call(callable, *with_input_args)
    end
  end

  (with_called_args.first || []).each do |key, value|
    it "passes the '#{key}' symbol to the callable" do
      hash = Hash[key, value]
      callable = proc do |_command, payload = {}|
        expect(payload).to match(a_hash_including(hash))
      end
      expect(callable).to receive(:call).once.and_call_original
      described_class.call(callable, *with_input_args)
    end
  end
  # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

  describe 'integration test', vcr: true do
    it 'raises no errors' do
      expect { JabberAdmin.send("#{with_name}!", *with_input_args) }.not_to \
        raise_error
    end
  end
end
