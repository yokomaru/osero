require 'spec_helper'
require './lib/osero'

RSpec.describe Osero do

  let(:osero) do
    described_class.new
  end

  describe 'method' do
    describe 'make_field' do
      example '4x4の配列を返すこと' do
        expect(osero.make_field).to eq [[".", ".", ".", "."], [".", "○", "●", "."], [".", "●", "○", "."], [".", ".", ".", "."]]
      end
    end

    describe 'convert_input_val_to_input_num_array' do
      context '0, 2という入力の場合' do
        example '[0,2]という配列を返すこと' do
          expect(osero.convert_input_val_to_input_num_array("0, 2")).to eq [0, 2]
        end
      end
    end

    describe 'check_input_num_array_size' do
      context '[0, 2]' do
        example 'チェックに通らないこと' do
          expect(osero.check_input_num_array_size([0])).to eq true
        end
      end

      context '[0, 2]' do
        example 'チェックに通ること' do
          expect(osero.check_input_num_array_size([0, 2])).to eq false
        end
      end
    end

    describe 'check_input_num_array_range' do
      context '[0, 2]' do
        example 'チェックに通ること' do
          expect(osero.check_input_num_array_range([0, 2])).to eq false
        end
      end

      context '[-1, -1]' do
        example 'チェックに通らないこと' do
          expect(osero.check_input_num_array_range([-1, -1])).to eq true
        end
      end
    end

    describe 'check_input_num_array_content' do
      context '[0, 2]' do
        example 'チェックに通ること' do
          expect(osero.check_input_num_array_content([0, 2])).to eq false
        end
      end

      context '[nil, 1]' do
        example 'チェックに通らないこと' do
          expect(osero.check_input_num_array_content([nil, 1])).to eq true
        end
      end
    end
  end
end