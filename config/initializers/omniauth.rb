module OmniAuth
  module Strategies
    class Dropbox < OmniAuth::Strategies::OAuth
      option :name, 'dropbox'
      option :client_options, {:site => 'https://www.dropbox.com'}
      option :sign_in, true
      option :force_sign_in, false

      def initialize(*args)
        super
        options.client_options[:authorize_path] = '/1/oauth/authorize' if options.sign_in?
        options.client_options[:access_token_path] = '/1/oauth/access_token' if options.sign_in?
        options.client_options[:request_token_path] = '/1/oauth/request_token' if options.sign_in?

        options.authorize_params[:force_sign_in] = 'true' if options.force_sign_in?
      end

      def uid
        raw_info['uid']
      end

      def info
        {
          'name' => raw_info['display_name'],
          'country' => raw_info['country'],
          'email' => raw_info['email'],
          'quota' => raw_info['quota_info']
        }
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get('/1/account/info').body)
      rescue ::Errno::ETIMEDOUT
        raise ::Timeout::Error
      end
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, 'DXpXtOqNTYvyhJTLVYOpnw', 'KjqMaFY8qqdO0oEiYK9D0Z5vZE6HuJW4BqCgOd9I'
  provider :dropbox, ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET']
end

