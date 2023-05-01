class Sleeper
    @queue = :sleep
    def self.perform
      sleep(5)
    end
end