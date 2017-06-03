require 'rails_helper'

module Validators
  RSpec.describe CellValidator do
    before(:all) do
      ActiveRecord::Base.connection.create_table :test_models, id: :uuid do |t|
        t.string :value
      end
    end

    after(:all) do
      ActiveRecord::Base.connection.drop_table :test_models
    end

    class TestModel < ActiveRecord::Base
      self.table_name = :test_models
      validates_with CellValidator, attributes: [:value]
    end

    let(:valid_cell_values) { %w(A5 A54 a5 a54 aA5 aA54) }
    let(:invalid_cell_values) { %w(A AA 5 55 54Ab 55Ab45 A5b Ab54ab A5/ a5? .A5) }
    let(:model) { TestModel.new }

    it 'allows blank values' do
      expect(model).to be_valid
      model.value = ''
      expect(model).to be_valid
    end

    it 'allows valid values' do
      valid_cell_values.each do |cell_value|
        model.value = cell_value
        expect(model).to be_valid
      end
    end

    it 'does not allow invalid values' do
      invalid_cell_values.each do |cell_value|
        model.value = cell_value
        expect(model).not_to be_valid
      end
    end
  end
end
