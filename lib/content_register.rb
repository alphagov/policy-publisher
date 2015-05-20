class ContentRegister
  def initialize
    @api_adapter = GdsApi::ContentRegister.new(Plek.new.find('content-register'))
  end

  def organisations
    api_adapter.entries('organisation').to_a
  end

  def people
    api_adapter.entries('person').to_a
  end

  def working_groups
    api_adapter.entries('working_group').to_a
  end

private
  attr_reader :api_adapter
end
