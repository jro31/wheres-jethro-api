class CheckInsRepresenter
  def initialize(check_ins)
    @check_ins = check_ins
  end

  def as_json
    check_ins.map { |check_in| CheckInRepresenter.new(check_in).as_json }
  end

  private

  attr_reader :check_ins
end
