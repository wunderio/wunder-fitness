class Activity < ActiveRecord::Base
  belongs_to :integration_user, class_name: "Integration::User"

  # Look for an existing activity or create a new one with provided ID and user.
  # Must provide integration user, because ID is not unique between services.
  def self.activity_with_service_activity_id(id, integration_user)
    activity = self.where(integration_user_id: integration_user.id, service_activity_id: id).take
    return activity unless activity.blank?
    return self.new(integration_user: integration_user, service_activity_id: id)
  end
end
