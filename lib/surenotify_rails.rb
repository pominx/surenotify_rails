require 'action_mailer'
require 'json'


Dir[File.dirname(__FILE__) + '/surenotify_rails/*.rb'].each {|file| require file }

module SurenotifyRails
end
