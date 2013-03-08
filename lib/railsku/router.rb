require 'net/http'

module Railsku
  class Router < Server
    @@next_port = 3000
    @@max_backends = 2
    @@backends = []
    @@running = []

    def self.backends
      @@backends
    end

    def self.setup_backends(bes)
      @@backends = bes
    end

    def self.reap
      target = @@running.first
      @@running.delete(target)
      target[:be].stop
    end

    def self.start_backend(be)
      if @@running.length >= @@max_backends
        #puts "No backends left!"
        reap
      end
      @@running << {:start => Time.now, :be => be, :pid => be.start(next_port) }
    end

    def self.find_backend(hostname)
      @@backends.each do |be|
        if be.hostname == hostname
          start_backend(be) unless be.running?
          return be
        end
      end
      nil
    end

private

    def self.next_port
      @@next_port += 1
    end
  end
end
