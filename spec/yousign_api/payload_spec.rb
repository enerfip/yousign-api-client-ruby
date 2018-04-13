require "spec_helper"

RSpec.describe YousignApi::Payload do
  class YousignApi::Payload::Dummy < YousignApi::Payload::Base
    attribute :item, type: "SubDummy"
    attribute :id
    attribute :name, default: "def"
    collection :subitems, type: "SubDummy"
    collection :other_collection
  end

  class YousignApi::Payload::SubDummy < YousignApi::Payload::Base
    attribute :name
  end

  def valid_dummy
    YousignApi::Payload::Dummy.new valid_params
  end

  def valid_params
    {
      item: valid_subdummy,
      id: 1,
      subitems: [valid_subdummy, valid_subdummy],
      other_collection: ["a", 1]
    }
  end

  def valid_subdummy
    YousignApi::Payload::SubDummy.new name: "alex"
  end

  describe "#new" do
    it "is instanciable with valid values" do
      expect(valid_dummy).to be_kind_of(YousignApi::Payload::Dummy)
    end

    it "raise errors if required field is missing" do
      expect {
        YousignApi::Payload::Dummy.new({})
      }.to raise_error "Missing required attribute 'item' for 'YousignApi::Payload::Dummy'"
    end

    it "raise errors if field is of wrong type" do
      expect {
        YousignApi::Payload::Dummy.new(valid_params.merge(item: "invalid"))
      }.to raise_error "Only 'YousignApi::Payload::SubDummy' instances are accepted for 'item'"
    end

    it "raise errors if collection is not an array" do
      expect {
        YousignApi::Payload::Dummy.new(valid_params.merge(other_collection: "invalid"))
      }.to raise_error "'other_collection' only accepts array"
    end

    it "raise errors if collection is of wrong type" do
      expect {
        YousignApi::Payload::Dummy.new(valid_params.merge(subitems: ["a"]))
      }.to raise_error  "Only 'YousignApi::Payload::SubDummy' instances are accepted for 'subitems'"
    end

    it "has default values" do
      expect(valid_dummy.name).to eq "def"
    end
  end

  describe "#to_payload" do
    it do
      expect(valid_dummy.to_payload).to eq item: {name: "alex"},
                                           id: 1,
                                           name: "def",
                                           subitems: [{name: "alex"}, {name: "alex"}],
                                           other_collection: ["a", 1]
      expect(
        YousignApi::Payload::SubDummy.new(name: "special").to_payload
      ).to eq name: "special"
    end
  end
end
