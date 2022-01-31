class CheckInPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    false # TODO - Update this
  end
end
