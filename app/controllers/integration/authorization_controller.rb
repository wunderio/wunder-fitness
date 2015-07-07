class Integration::AuthorizationController < ApplicationController
  def index
    @service_connect_links = []

    if current_user
      Dir["app/models/integration/services/*.rb"].each { |file| load file }
      Integration::Services.constants.each do |service_name|
        service = Integration::Services.const_get(service_name).new
        service_machine_name = service_name.to_s.underscore

        # Get connected status via integration user 
        # and inject possible token to service.
        existing_integration_user = current_user.integration_user(service_machine_name)
        service.access_token = existing_integration_user.token if existing_integration_user

        options = {
          :site => service.site_url,
        }
        options[:authorize_url] = service.oauth_authorize_url if service.oauth_authorize_url
        oauth2_client = OAuth2::Client.new(service.client_id, service.client_secret, options)
        service.oauth2_client = oauth2_client
        service.update_activities(existing_integration_user)

        authorize_options = {
          :redirect_uri => "http://127.0.0.1:8888/oauth2/callback/authorization/#{service_machine_name}",
        }
        authorize_options[:scope] = service.oauth_scopes if service.oauth_scopes
        authorize_url = oauth2_client.auth_code.authorize_url(authorize_options)
        @service_connect_links << {:service => service, :integration_user => existing_integration_user, :url => authorize_url}
      end
    end
  end

  # This authorization callback gets called by the OAuth2 provider once
  # the user has authorized our app on the provider's site.
  def oauth2_authorization_callback
    require 'oauth2'

    if not current_user
      redirect_to import_path, alert: "You need to sign in to connect with an external service."
      return
    end

    # Get service from URL.
    service_name = params[:service]
    load "app/models/integration/services/#{service_name}.rb"
    service = Integration::Services.const_get(service_name.camelize).new
    code_value = params[:code]

    if code_value.blank?
      redirect_to import_path, alert: "Could not connect with #{service_name.camelize}, OAuth2 authorization code missing from return call."
      return
    end

    # Create client and get token
    options = {
      :site => service.site_url
    }
    options[:token_url] = service.oauth_token_url if service.oauth_token_url
    client = OAuth2::Client.new(service.client_id, service.client_secret, options)
    token_options = {
      :redirect_uri => "http://127.0.0.1:8888/oauth2/callback/authorization/#{service_name}"
    }
    token_options[:headers] = service.oauth_headers
    token_data = client.auth_code.get_token(code_value, token_options)

    # https://api.moves-app.com/oauth/v1/access_token?grant_type=authorization_code&code=lX7giiuyJr8_5MMK0SMUR4DY0No13n57DpvD4KrJGPJmAG_6zPjVT17H3bZtc9xZ&client_id=AoqJ_H6L9hHB51U6BOzo8yMJnEL9AISr&client_secret=Xz836Xc9iv_Nqtl2M6gH6VeclgF25n9w5PgZfVZbAm33SDWZYXaV4d4rRUFB5QQf&redirect_uri=http://127.0.0.1:8888/oauth2/token/moves

    integration_user = current_user.integration_user_by_service_id(service.user_id(token_data), service.name)
    integration_user.token = token_data.token
    integration_user.save

    redirect_to import_path, status: "Connected #{service_name.humanize} successfully."
    return
  end
end