class Notification
  include MongoMapper::Document
  timestamps!

  key :_type, String

  key :author_id, BSON::ObjectId
  belongs_to :author

  key :target_id, String
  key :target_type, String
  belongs_to :target, :polymorphic => true

  key :read, Boolean, :default => false
end
