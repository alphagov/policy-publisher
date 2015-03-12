require 'gds_api/publishing_api'
require 'gds_api/content_register'
require 'gds_api/rummager'

module PolicyPublisher
  def self.register_service(name, service)
    @services ||= {}

    @services[name] = service
  end

  def self.services(name)
    @services[name] or raise ServiceNotRegisteredException.new(name)
  end

  class ServiceNotRegisteredException < Exception; end
end

PolicyPublisher.register_service(:publishing_api, GdsApi::PublishingApi.new(Plek.new.find('publishing-api')))
PolicyPublisher.register_service(:rummager, GdsApi::Rummager.new(Plek.new.find('search')))
PolicyPublisher.register_service(:content_register, ContentRegister.new)
