# frozen_string_literal: true

require 'econfig'
require 'sinatra'
require 'rack-flash'
require 'rack/ssl-enforcer'
require 'rack/session/redis'

# Base class for ConfigShare Web Application
class FileSystemSyncApp < Sinatra::Base
  extend Econfig::Shortcut

  ONE_MONTH = 2_592_000 # One month in seconds

  configure :production do
    use Rack::SslEnforcer
  end

  set :views, File.expand_path('../../views', __FILE__)
  set :public_dir, File.expand_path('../../public', __FILE__)

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)

    SecureMessage.setup(settings.config)
    SecureSession.setup(settings.config)
  end

  configure :development, :test do
    use Rack::Session::Pool, expire_after: ONE_MONTH
  end

  configure :production do
    use Rack::Session::Redis, expire_after: ONE_MONTH, redis_server: settings.config.REDIS_URL
  end

  use Rack::Flash

  def redirected_if_not_logged_in()
    return true if @current_account
    flash[:error] = 'You should log in first.'
    redirect '/account/login'
    halt
  end

  before do
    @current_account = SecureSession.new(session).get(:current_account)
    @auth_token = SecureSession.new(session).get(:auth_token)
  end

  get '/' do
    slim :home
  end
end
