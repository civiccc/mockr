class Setting < ActiveRecord::Base
  def self.[](key)
    self.find_by_key(key.to_s).try(:value)
  end
end
