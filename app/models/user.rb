class User < ActiveRecord::Base
  has_many :integration_users, class_name: "Integration::User"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def integration_user(service_name)
    Integration::User.users_by_service(service_name).find_by user_id: 1
  end

  def integration_user_by_service_id(user_service_id, service_name, create: true)
    user = Integration::User.where(user_id: self.id).users_by_service(service_name).user_by_user_service_id(user_service_id)
    return user unless user.blank? and create
    return Integration::User.new(:user_service_id => user_service_id, :service_name => service_name, :user_id => self.id)
  end
end
