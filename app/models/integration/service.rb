class Integration::Service
  attr_reader :oauth_version
  attr_reader :oauth_scopes
  attr_reader :oauth_authorize_url
  attr_reader :oauth_token_url

  attr_reader :client_id
  attr_reader :client_secret
  attr_reader :site_url

  def initialize
    @client_id = Figaro.env.send(name + "_client_id!")
    @client_secret = Figaro.env.send(name + "_client_secret!")
    @site_url = Figaro.env.send(name + "_site_url!")

    # Defaults
    @oauth_version = 2
    @oauth_scopes = "activity"

    # Call configuration method.
    configuration
  end

  def configuration

  end

  def name
    self.class.name.demodulize.underscore
  end

  #  What happens when token appears?
  def access_token=(access_token)
    @access_token = access_token
  end

  def access_token
    @access_token
  end

  def update_activities
    raise NotImplementedError "All service subclasses must implement the update_activities method."
  end

  # Return the unique user ID from user data.
  def user_id(data)
    raise NotImplementedError "All service subclasses must implement the user_id method."
  end
end