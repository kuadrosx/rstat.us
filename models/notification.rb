class Notification
  require 'cgi'
  include MongoMapper::Document

  key :_type, String

  key :user_id, BSON::ObjectId
  belongs_to :user

  key :target_id, String
  key :target_type, String
  belongs_to :target, :polymorphic => true

  key :read, Boolean, :default => false
end
