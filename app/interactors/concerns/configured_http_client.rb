module ConfiguredHttpClient
  extend ActiveSupport::Concern

  included do
    def http_client
      HttpClient.new timeout: 10,
                     connecttimeout: 10,
                     verbose: false,
                     proxy: ENV["PROXY_HOST"].presence,
                     proxytype: ENV["PROXY_TYPE"].presence
    end
  end
end
