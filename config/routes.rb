Rails.application.routes.draw do
  namespace "api" do
    namespace "v1" do
      bot_salt = ENV["BOT_URL_SALT"].downcase # downcase for error on nil
      post "telegram_web_hook_#{bot_salt}", to: "telegram#webhook", as: :telegram_webhook
    end
  end
end
