# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

secret = ENV['slog_secret']

if secret.nil?
  secret = 'c4e87a0b812a57b074de00f0cab7f11e687bc336da3d7d80859cfbbd81da50a177c6318a04e28a2d74020da7321ae4dd5e318081fd957d9984dd7800d01a4427'
end

Hypercouch::Application.config.secret_token = secret