require 'gds_api/publishing_api'
require 'gds_api/content_register'
require 'gds_api/rummager'

module PolicyPublisher
  def self.services(name, service = nil)
    @services ||= {}

    if service
      @services[name] = service
      return true
    else
      if @services[name]
        return @services[name]
      else
        raise ServiceNotRegisteredException.new(name)
      end
    end
  end

  class ServiceNotRegisteredException < Exception; end
end


PolicyPublisher.services(:publishing_api, GdsApi::PublishingApi.new(Plek.new.find('publishing-api')))
PolicyPublisher.services(:rummager, GdsApi::Rummager.new(Plek.new.find('search')))
PolicyPublisher.services(:content_register, GdsApi::ContentRegister.new(Plek.new.find('content-register')))
