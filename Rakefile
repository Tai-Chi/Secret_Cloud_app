# frozen_string_literal: true

require 'rake/testtask'
require './init.rb'

namespace :crypto do
  task :crypto_requires do
    require 'rbnacl/libsodium'
    require 'base64'
  end

  desc 'Create rbnacl key'
  task msg_key: [:crypto_requires] do
    puts "New MSG_KEY: #{SecureMessage.generate_key}"
  end

  desc 'Create cookie secret'
  task session_secret: [:crypto_requires] do
    puts "New session secret (base64 encoded): #{SecureSession.generate_secret}"
  end
end

namespace :session do
  desc 'Wipe all sessions stored in Redis'
  task :wipe do
    require 'redis'
    puts 'Deleting all sessions from Redis session store'
    wiped = SecureSession.wipe_redis_sessions
    puts "#{wiped.count} sessions deleted"
  end
end
