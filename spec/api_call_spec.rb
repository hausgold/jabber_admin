# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JabberAdmin::ApiCall do
  describe '.perform' do
    context 'when api call is not successful' do
      it 'raises an error' do
        allow(described_class)
          .to receive(:post)
          .and_return(OpenStruct.new(success?: false))

        expect { described_class.perform('foobar') }
          .to raise_error(JabberAdmin::ApiError)
      end
    end

    context 'when api call is successful' do
      let(:response) { OpenStruct.new(success?: true, body: 'foobar') }

      it 'returns the response' do
        allow(described_class)
          .to receive(:post)
          .and_return(response)

        expect(described_class.perform('register')).to eq(response)
      end
    end
  end
end
