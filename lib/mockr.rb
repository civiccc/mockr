module Mockr
  def self.unclaimed?
    User.count == 0
  end
end
