class HttpClient
  def initialize(options = {})
    @options = options
  end

  def get(url)
    Typhoeus.get url, @options
  end

  def post(url, args = {})
    options = @options
    options = options.merge(body: args) if args.present?
    Typhoeus.post url, options
  end
end
