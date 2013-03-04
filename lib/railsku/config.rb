module Railsku
  @@config = {}

  def self.configure(opts = {})
    @@config.merge! opts.dup
  end

  def self.config
    @@config.dup
  end
end
