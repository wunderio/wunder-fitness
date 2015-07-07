class Integration::Services::MapMyRun < Integration::Service
  def configuration
    @oauth_scopes = nil
    @oauth_authorize_url = "/v7.1/oauth2/authorize"
    @oauth_token_url = "https://oauth2-api.mapmyapi.com/v7.1/oauth2/uacf/access_token"
    @oauth_headers = {
      "Api-Key" => @client_id,
    }
  end

  def access_token=(access_token)
    @access_token = access_token
  end

  def update_activities(integration_user)
    if @access_token
      workouts_response = self.query("/v7.1/workout/?user=#{integration_user.user_service_id}", @oauth2_client)
      workouts_data = JSON.parse(workouts_response.body)
      workouts_data["_embedded"]["workouts"].each do |api_activity|
        activity_service_id = api_activity["_links"]["self"]["id"]
        activity = Activity.activity_with_service_activity_id(activity_service_id, integration_user)

        activity.distance = api_activity["aggregates"]["distance_total"]
        activity.date = api_activity["start_datetime"]
        activity.save
      end
    end
  end

  def user_id(data)
    data["user_id"]
  end

  def query(path, oauth2_client)
    token = OAuth2::AccessToken.new(oauth2_client, @access_token)
    token.get(
      path,
      :headers => {
        "Api-Key" => @client_id,
        "Content-Type" => "application/json",
      }
    )
  end
end