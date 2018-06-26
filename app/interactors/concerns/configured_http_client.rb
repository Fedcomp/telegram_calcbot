module ConfiguredHttpClient
  extend ActiveSupport::Concern

  included do
    def http_client
      HttpClient.new timeout: 10,
                     connecttimeout: 10,
                     verbose: false,
                     proxy: "tor:9050",  # TODO: Configurable in ENV's
                     proxytype: "socks5" # TODO: Configurable in ENV's
    end
  end
end
