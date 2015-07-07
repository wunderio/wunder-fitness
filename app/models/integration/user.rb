class Integration::User < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  has_many :activity

  def self.table_name_prefix
    'integration_'
  end

  def self.users_by_service(service_name)
    where(service_name: service_name)
  end

  def self.user_by_user_service_id(user_service_id)
    find_by user_service_id: user_service_id
  end
end