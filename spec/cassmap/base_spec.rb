require 'spec_helper'

describe Cassmap::Base do
  let(:my_model) { MyModel.new(
                    id: UUIDTools::UUID.timestamp_create,
                    name: "John",
                    date_started: Date.new(2013,1,23),
                    times_visited: 1)
                  }
  describe "saving records" do
    it "saves record" do
      expect(my_model.save).to be_true
      rows = cql.execute "select * from my_models"
      expect(rows.count).to eql 1
      first_row = rows.first
      expect(first_row["name"]).to eq "John"
      expect(first_row["date_started"]).to eq Time.new(2013,1,23)
      expect(first_row["times_visited"]).to eq 1
    end
  end
  describe "deleting record"
  describe "creating records"
  describe "retrieving records"
  describe "dirty"
  describe "callbacks"
end
