require 'spec_helper'

describe User do
  
  before do 
  	@user = User.new(name: "Example User", email: "user@example.com",
  							password: "foobar", password_confirmation: "foobar") 
  end

  subject { @user }

  #------------------ FIELDS --------------------
  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }                  #VIRTUAL
  it { should respond_to :password_confirmation }     #VIRTUAL
  it { should respond_to :remember_token }
  it { should respond_to :admin }

  #------------------ METHODS -------------------
  it { should respond_to :authenticate }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do 
      @user.save! 
      @user.toggle! :admin
    end

    it { should be_admin }
  end

  describe "when name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid}
  end

  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when name is to short" do
    before { @user.name = "aa" }
    it { should_not be_valid }
  end

  describe "when name is to long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "foo@ExAmpLe.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  	  adresses = %w[user@foo,com user_at_foo.org eample.user@foo. 
  					foo@bar_baz.com foo@bar+baz.com foo@bar..com]
  	  adresses.each do |invalid_address|
  		  @user.email = invalid_address
  		  expect(@user).not_to be_valid
  	  end
  	end
  end

  describe "when email addres is already taken" do
  	before do
  	  user_with_same_email = @user.dup
  	  user_with_same_email.email = @user.email.upcase
  	  user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  #TESTING PASSWORD AUTHENTICATIONS
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
  	it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end	

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by email: @user.email }

    describe "with valid password" do
      it { should eq found_user.authenticate @user.password }
    end

    describe "with invalid password" do 
      let(:user_for_invalid_password) { found_user.authenticate "invalid" }

      it { should_not eq user_for_invalid_password }
      specify { expect( user_for_invalid_password ).to be_false }
    end

    describe "with invalid password" do
      let (:user_for_invalid_password) { found_user.authenticate "invalid" }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
