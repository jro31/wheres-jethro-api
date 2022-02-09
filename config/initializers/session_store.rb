if Rails.env == 'production'
  Rails.application.config.session_store :cookie_store, key: "_wheres_jethro", domain: "api.wheresjethro.com"
else
  Rails.application.config.session_store :cookie_store, key: "_wheres_jethro"
end
