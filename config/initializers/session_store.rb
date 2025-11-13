# Rails.application.config.session_store :cookie_store,
#   key: '_rails_session_demo_session',
#   httponly: true,
#   secure: Rails.env.production?,   # true in prod; false on localhost
#   same_site: :lax,
#   expire_after: 14.days

Rails.application.config.session_store :active_record_store, key: '_session_cookie_demo'
