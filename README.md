# wunder-fitness

A web app prototype that imports fitness activities from different services. Has Devise for user management, but hasn't got any permission management yet.

## Service integration

Any service that uses OAuth2 for authorization and provides uniquely identifiable activities should be easy to integrate.

Take a look at app/models/integration/service.rb and the existing implementations in app/models/integration/services/.
