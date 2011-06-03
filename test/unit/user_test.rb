# encoding: UTF-8
require 'require_relative' if RUBY_VERSION[0,3] == '1.8'
require_relative '../test_helper'

describe User do

  include TestHelper

  describe "#at_replies" do
    it "returns all at_replies for this user" do
      u = User.create(:username => "steve")
      update = Update.create(:text => "@steve oh hai!")
      Update.create(:text => "just some other update")

      assert_equal 1, u.at_replies({}).count
      assert_equal update.id, u.at_replies({}).first.id
    end

    it "returns all at_replies for a username containing ." do
      u = Factory.create(:user, :username => "hello.there")
      u1 = Factory.create(:user, :username => "helloothere")
      update = Update.create(:text => "@hello.there how _you_ doin'?")

      assert_equal 1, u.at_replies({}).count
      assert_equal 0, u1.at_replies({}).count
    end
  end

  describe "username" do
    it "must be unique" do
      Factory(:user, :username => "steve")
      u = Factory.build(:user, :username => "steve")
      refute u.save
    end

    it "must be unique regardless of case" do
      Factory(:user, :username => "steve")
      u = Factory.build(:user, :username => "Steve")
      refute u.save
    end

    it "must not be long" do
      u = User.new :username => "burningTyger_will_fail_with_this_username"
      refute u.save
    end

    it "must not contain special chars" do
      ["something@something.com", "another'quirk", ".boundary_case.", "another..case", "another/random\\test", "yet]another", ".Ὁμηρος", "I have spaces"].each do |i|
        u = User.new :username => i
        refute u.save, "contains restricted characters."
      end
      ["Ὁμηρος"].each do |i|
        u = User.new :username => i
        assert u.save, "characters being restricted unintentionally."
      end
    end

    it "must not be empty" do
      u = User.new :username => ""
      refute u.save, "blank username"
    end

    it "must not be nil" do
      u = User.new :username => nil
      refute u.save, "nil username"
    end
  end

  describe "twitter auth" do
    it "has twitter" do
      u = Factory.create(:user)
      a = Factory.create(:authorization, :user => u)
      assert u.twitter?
    end

    it "returns twitter" do
      u = Factory.create(:user)
      a = Factory.create(:authorization, :user => u)
      assert_equal a, u.twitter
    end
  end

  describe "facebook auth" do
    it "has facebook" do
      u = Factory.create(:user)
      a = Factory.create(:authorization, :user => u, :provider => "facebook")
      assert u.facebook?
    end

    it "returns facebook" do
      u = Factory.create(:user)
      a = Factory.create(:authorization, :user => u, :provider => "facebook")
      assert_equal a, u.facebook
    end
  end

  describe "reset password" do
    it "sets the token" do
      u = Factory.create(:user)
      assert_nil u.perishable_token
      assert_nil u.password_reset_sent
      u.set_password_reset_token
      refute u.perishable_token.nil?
      refute u.password_reset_sent.nil?
    end

    it "changes the password" do
      u = Factory.create(:user)
      u.password = "test_password"
      u.save
      prev_pass = u.hashed_password
      u.reset_password("password")
      assert u.hashed_password != prev_pass
    end
  end

  describe "following" do
    it "should create an notification for the followed user" do
      at = Factory(:author)
      f = Factory(:feed, :author =>at)
      u = Factory(:user, :username => "someone", :feed => f, :author => at)
      at1 = Factory(:author)
      f1 = Factory(:feed, :author =>at1)
      u1 = Factory(:user, :username => "somebody", :feed => f1, :author => at1)

      n = FollowedNotification.new(:author => at)
      FollowedNotification.expects(:new).with(:author => at).returns(n)
      u1.follow! f.url
      assert_equal at.notifications.count, 1
    end
  end
end
