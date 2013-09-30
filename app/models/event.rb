class Event < ActiveRecord::Base
	attr_accessor :title, :location, :date, :description, :url
	
	validates_uniqueness_of :url 
	
end
