class Integration::Services::Strava < Integration::Service
  def access_token=(access_token)
    @access_token = access_token
    if @access_token
      @client = Strava::Api::V3::Client.new(:access_token => @access_token)
    end
  end

  def update_activities(integration_user)
    @client.list_athlete_activities.each do |api_activity|
      activity = Activity.activity_with_service_activity_id(api_activity["id"], integration_user)
      activity.distance = api_activity["distance"]
      activity.date = api_activity["start_date_local"]
      activity.save
    end
  end

  def user_id(data)
    data.params["athlete"]["id"]
  end
end