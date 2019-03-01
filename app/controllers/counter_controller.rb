class CounterController < ApplicationController
  def report
  	@count = Counter.last

 
end
