class Url < ApplicationRecord

	searchkick word_start: [:short_url]

	require 'elasticsearch/model'

	include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings do
    mappings dynamic: false do
      indexes :short_url, type: :text
    end
 


	require "redis"
	require 'date'

	index_name('urls')

	#def as_indexed_json(options={})
  	#	as_json
  	#	(
    #		only: [:long_url, :short_url]
  	#	)
	#end

	
	#Url.import

	after_commit :increment_count_generated_url

	require 'digest/sha1'
	#require 'digest/MD5'
	require 'base64'

	validates :long_url, presence: true, on: :create
  	validates_format_of :long_url,
    with: /\A(?:(?:http|https):\/\/*)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/

    def increment_count_generated_url
    	$redis.incr (Date.today)
  	end

    def self.shorten_url(long_url)
    	@url = Url.new
    	@url.long_url = long_url
		@url.short_url = self.generate_short_url(long_url)
		resp = @url.save! ? @url.short_url : "invalid url"
		return resp
    end

    

	def self.generate_short_url(long_url)
		regex_for_domain=/.*\//
		domain_name = long_url.match(regex_for_domain).to_s
		encrypted_domain_name = Digest::SHA1.hexdigest(domain_name)[0, 3]
		id_for_encryption = Url.last.id.to_s
		#id_for_encryption = 10092.to_s

		encrypted_id = Base64.encode64(id_for_encryption)[0,3]

		short_url = encrypted_domain_name + encrypted_id

		short_url=Digest::MD5.hexdigest(short_url)[0, 6]

		return short_url
	end

end

