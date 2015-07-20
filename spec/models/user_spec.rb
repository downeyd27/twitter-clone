# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do

  before do
    @user = User.new(name: "Example User", email: "user@test.com", password: "foobar", password_confirmation: "foobar")
  end


  it { expect(@user).to respond_to(:name) }
  it { expect(@user).to respond_to(:email) }
  it { expect(@user).to respond_to(:password_digest) }
  it { expect(@user).to respond_to(:password) }
  it { expect(@user).to respond_to(:password_confirmation) }
  it { expect(@user).to respond_to(:authenticate) }

  it { expect(@user).to be_valid }

  describe "name is not present" do
    before { @user.name = " " }
    it { expect(@user).to_not be_valid }
  end

  describe "email is not present" do
    before { @user.email = " " }
    it { expect(@user).to_not be_valid }
  end

  describe "name is too long" do
    before { @user.name = "Z" * 51 }
    it { expect(@user).to_not be_valid}
  end

  describe "email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).to_not be_valid
      end
    end
  end

  describe "email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { expect(@user).to_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email) == mixed_case_email.downcase
    end
  end

  describe "password is not present" do
    before { @user.password = @user.password_confirmation = " "}
    it { expect(@user).to_not be_valid }
  end

  describe "password doesn't match confirmation password" do
    before { @user.password_confirmation = "mismatch" }
    it { expect(@user).to_not be_valid }
  end

  describe "password_confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { expect(@user).to_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "z" * 5}

    it { expect(@user).to be_invalid}
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { expect(@user).to eq(found_user.authenticate(@user.password)) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid")}

      it { expect(@user).to_not eq(user_for_invalid_password)}
      specify { expect(user_for_invalid_password).to be_falsey }
    end

  end
end