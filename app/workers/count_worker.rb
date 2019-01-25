class CountWorker
  require 'date'
  include Sidekiq::Worker

  def perform
  	puts "Started at #{Time.now}"
  	@counter = Counter.new
  	@counter.date = Date.today
  	@counter.count = $redis.get(Date.today)
  	@counter.save
  end
end
