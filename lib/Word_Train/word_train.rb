class Wordpress

	def initialize
		@client = Mysql2::Client.new(:host     => "localhost",
		                            :username => "root",
		                            :password => "root",
		                            :port     => "8889",
		                            :database => "wordpress",
		                            :socket   => "/Applications/MAMP/tmp/mysql/mysql.sock");
	end

	def view(id)
		return @client.query("SELECT * FROM `wp_posts` WHERE `ID` = '" + id.to_s + "' ")
	end

	def termRelationshipsQuery (id)
		return @client.query("SELECT * FROM `wp_term_relationships` WHERE `object_id` = '" + id.to_s + "' ")
	end

	def termsQuery (id)
		return client.query("SELECT * FROM `wp_terms` WHERE `term_id` = '" + id.to_s + "' ")
	end

	def categories (id)
		first = true
		categories = ""

		termRelationshipsQuery(id).each do |relationship|

			puts "Iterating relationship " + relationship["object_id"].to_s
			relationshipId = relationship["term_taxonomy_id"].to_s

			termsQuery(relationshipId).each do |term|

				puts "Iterating Term " + term["name"]
				if first
					categories = term["name"]
					first = false
				elsif first == false
					categories = categories + ", " + term["name"]
				end

				if Category.exists?(name: term["name"]) == false
					Category.create(name: term["name"], code: term["slug"])
				end
			end
		end
		return categories
	end

	def posts
		return @client.query("SELECT * FROM `wp_posts` WHERE `post_type` = 'post'")
		# AND `post_status` = 'publish'
	end

	def images
		query = @client.query("SELECT * FROM `wp_posts`
													    WHERE `post_status` = 'publish'
															AND `post_type` = 'attachment' ");
		return query
	end

end