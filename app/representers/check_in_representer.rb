class CheckInRepresenter
  def initialize(check_in)
    @check_in = check_in
  end

  def as_json
    {
      id: check_in.id,
      name: check_in.name,
      description: check_in.description,
      latitude: check_in.latitude,
      longitude: check_in.longitude,
      accuracy: check_in.accuracy,
      icon: check_in.icon,
      datetime: check_in.created_at
    }
  end

  private

  attr_reader :check_in
end
