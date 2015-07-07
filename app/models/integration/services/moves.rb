class Integration::Services::Moves < Integration::Service
  def configuration
    @oauth_version = 2
    @oauth_scopes = "activity"
    @oauth_authorize_url = "/oauth/v1/authorize"
    @oauth_token_url = "/oauth/v1/access_token"
  end

  def access_token=(access_token)
    @access_token = access_token
    if @access_token
      @client = Moves::Client.new(access_token)
    end
  end

  def update_activities(integration_user)
    if (@client)
      @client.daily_activities(:pastDays => 31).each do |day|
        # Import each segment as its own activity.
        if day["segments"]
          day["segments"].each do |segment|
            segment["activities"].each do |api_activity|
              # Can't be in the transport group.
              next if api_activity["group"] == "transport"

              # Moves does not have unique IDs for activities. What it has though
              # is obviously a unique start time for each segment and activity.
              # Combined with the user service ID, they become unique within Moves.
              activity_service_id = integration_user.user_service_id + "_" + api_activity["startTime"]
              activity = Activity.activity_with_service_activity_id(activity_service_id, integration_user)

              activity.distance = api_activity["distance"]
              activity.date = api_activity["startTime"]
              activity.save
            end unless not segment["activities"]
          end
        end
      end
    end
  end

  def self.user_id(data)
    data["user_id"]
  end
end