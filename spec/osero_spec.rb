require 'spec_helper'
require './osero'

RSpec.describe Osero do

  let(:osero) do
    described_class.new
  end

  describe 'method' do
    describe 'make_field' do
      it 'work' do
        expect(osero.make_field).to eq [[".", ".", ".", "."], [".", "○", "●", "."], [".", "●", "○", "."], [".", ".", ".", "."]]
      end
    end

    describe 'convert_input_val_to_input_num_array' do
      it 'work' do
        expect(osero.convert_input_val_to_input_num_array("0, 2")).to eq [0, 2]
      end
    end

    describe 'check_input_num_array_size' do
      it 'work' do
        expect(osero.check_input_num_array_size([0, 2])).to eq false
      end

      it 'not work' do
        expect(osero.check_input_num_array_size([0])).to eq true
      end
    end

    describe 'check_input_num_array_range' do
      it 'work' do
        expect(osero.check_input_num_array_range([0, 2])).to eq false
      end

      it 'not work' do
        expect(osero.check_input_num_array_range([-1, -1])).to eq true
      end
    end

    describe 'check_input_num_array_content' do
      it 'work' do
        expect(osero.check_input_num_array_content([0, 2])).to eq false
      end

      it 'not work' do
        expect(osero.check_input_num_array_content([nil, 1])).to eq true
      end
    end

  end
end