module Telegram
  class Client
    TELEGRAM_API_URL = "https://api.telegram.org".freeze

    def initialize(token, http_client)
      @token = token
      @http_client = http_client
    end

    # dynamic methods for api calls
    def method_missing(name, args = {})
      api_method_name = name.to_s.camelize(:lower)
      url = "#{TELEGRAM_API_URL}/bot#{@token}/#{api_method_name}"

      response = @http_client.post(url, args)

      if response.success?
        # TODO: Faulty, fix it
        Hashie::Mash.new(JSON.parse(response.body))
      else
        Hashie::Mash.new(
          ok: false, http_code: response.code, timeout: response.timed_out?,
          body: response.body
        )
      end
    end
  end
end
