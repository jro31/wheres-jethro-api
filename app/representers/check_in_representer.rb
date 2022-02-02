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
      datetime: check_in.created_at,
      datetime_humanized: humanize_datetime
    }
  end

  private

  def humanize_datetime
    parsed_datetime = check_in.time_zone ? check_in.created_at.in_time_zone(check_in.time_zone) : check_in.created_at

    {
      date: parsed_datetime.strftime("#{parsed_datetime.day.ordinalize} %b '%y"),
      time: parsed_datetime.strftime('%H:%M %Z')
    }
  end

  attr_reader :check_in
end
