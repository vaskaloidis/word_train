# rake Bluehelmet:import_wp

require 'redcarpet'
# require 'platform-api'
require 'Word_Train/word_train'
require 'Upmark'

namespace :Word_Train do
	desc "Import Wordpress"
	task :import_wp => :environment do

		puts "Starting Wordpress Import"

		wp    = Wordpress.new
		posts = wp.posts

		imgs = wp.images

		posts.each do |row|

			puts "*** Importing Article " + row["ID"] + " - " + row["post_title"] + " *** "

			imgs.each do |row| # Image
				puts row["img-data"]
				articles.img = row["img-data"] # TODO: Images for the post
			end

			# HTML -> Markdown
			# renderer = Redcarpet::Render::HTML.new(no_links: true, hard_wrap: true)
			# markdown = Redcarpet::Markdown.new(renderer, extensions = {})
			# article.content    = markdown.render(row["post_content"])
			# article.content    = Render::Markdown.new.render(row["post_content"])
			# filtered = HTMLPage.new :contents => row["post_content"]

			# postContent = ReverseMarkdown.convert(input, unknown_tags: :raise, github_flavored: true)

			puts row["post_content"]

			puts "*******************"

			puts "Converted to Markdown: "
			postContent = Upmark.convert(row["post_content"])
			puts postContent

			categories = wp.categories(row["ID"])

			article            = Article.new
			article.name       = row["post_title"]
			article.shortname  = row["post_name"]
			article.excerpt    = row["post_excerpt"]
			article.created_at = row["post_date"]
			article.updated_at = row["post_modified"]
			article.content    = postContent
			article.categories = categories

			if row["post_status"].equal?("publish")
				puts "Article Published"
				article.published = true
			elsif row["post_status"].equal?("draft")
				puts "Article Draft"
				article.published = false
			end

			article.save

			puts "Post added - " + article.name
		end

	end


	desc "View Post"
	task :view_post => :environment do
		wp = Wordpress.new
		wp.view(82).each do |row|

			puts row["post_content"]

			puts "*******************"

			puts "Convert to Markdown: "
			postContent = Upmark.convert(row["post_content"])
			puts postContent
			end
	end

	desc "Reset Database"
	task :reset_database => :environment do
		Rake::Task["db:drop"].invoke
		Rake::Task["db:create"].invoke
		Rake::Task["db:schema:load"].invoke
		Rake::Task["db:migrate"].invoke
	end

	desc "Import Projects data file"
	task :convert_projects_to_markdown => :environment do

		Project.all.each do |project|
			oldProject = project.content

			project.content = Upmark.convert(oldProject)

			project.save

		end

	end

	desc "Clear Cache"
	task :clear_cache => :environment do
		Rake::Task["tmp:clear"].invoke
		Rake::Task["tmp:cache:clear"].invoke
		Rake::Task["assets:clean"].invoke
	end

	# Clear Cache (Memcache)
	desc 'Clear memcache'
	task Qclear_memcache => :environment do
		# Rails.cache.clear
		::Rails.cache.clear
		CACHE.flush
	end

	def heroku(cmd, app_name)
		Bundler.with_clean_env do
			sh "heroku #{cmd} --app #{app_name}"
		end
	end

end
