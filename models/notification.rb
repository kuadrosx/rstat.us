class Notification
  include MongoMapper::Document
  timestamps!

  key :_type, String

  belongs_to :author

  key :target_id, BSON::ObjectId
  key :target_type, String
  belongs_to :target, :polymorphic => true

  key :read, Boolean, :default => false
end
