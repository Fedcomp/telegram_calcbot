namespace :telegram do
  desc "register telegram webhook endpoint"
  task register_webhook: :environment do
    Telegram::SetWebhook.run!
    puts "No errors = success!"
  end
end
