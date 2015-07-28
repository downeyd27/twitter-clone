# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Relationship, type: :model do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { expect(relationship).to be_valid }

  describe "follower methods" do
    it { expect(relationship).to respond_to(:follower) }
    it { expect(relationship).to respond_to(:followed) }
    # 2 Failing tests
    its(:follower) { should eq follower }
    its(:followed) { should eq followed }
  end

  describe "when followed id is not present" do
      before { relationship.followed_id = nil }
      it { should_not be_valid }
    end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
end