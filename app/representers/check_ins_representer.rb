class CheckInsRepresenter
  def initialize(check_ins)
    @check_ins = check_ins
  end

  def as_json
    check_ins.map do |check_in|
      {
        name: check_in.name,
        description: check_in.description,
        latitude: check_in.latitude,
        longitude: check_in.longitude,
        accuracy: check_in.accuracy
      }
    end
  end

  private

  attr_reader :check_ins
end
