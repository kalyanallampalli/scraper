# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_scraper_session',
  :secret      => '1fc915f57a2927357566334cbb19263ecd7f9a46d84471e511de0cd6b44930307d2c7bbe91ccd18a5fa7fd5942697c4e4ded7c917776c06e61187ae0b0da673f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
