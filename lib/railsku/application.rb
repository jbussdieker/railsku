module Railsku
  class Application
    attr_accessor :name, :hostname, :path, :pid, :port

    def initialize(name, hostname, path)
      @name = name
      @hostname = hostname
      @path = path
      @pid = nil
    end

    def start(port = 3000)
      puts "Starting #{name}"
      raise "Already running" if running?
      @port = port
      @pid = Process.fork do
        process = IO.popen("
          cd #{path}
          unset BUNDLE_GEMFILE
          unset RUBYOPT
          unicorn -p #{port}
        ")
        #puts "Process pid: #{process.pid}"
        Signal.trap("HUP") { 
          #puts "Ouch #{process.pid}!"

          pipe = IO.popen("ps -edf | grep #{process.pid}")
          child_pids = pipe.readlines.collect do |line|
            parts = line.split(/\s+/)
            parts[1].to_i if parts[2] == process.pid.to_s and parts[1] != pipe.pid.to_s
          end.compact
          child_pids.each do |cp|
            Process.kill("QUIT", cp)
          end
        }
        process.readlines
      end
      sleep 1
      @pid
    end

    def running?
      @pid != nil
    end

    def stop
      raise "Not running" unless @pid
      Process.kill("HUP", @pid)
      @pid = nil
    end
  end
end
