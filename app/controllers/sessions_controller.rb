require 'koala'
class SessionsController < ApplicationController
  def new
  end

	def create 
		auth_hash = request.env['omniauth.auth']
		@authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
		if @authorization
		  render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
		else
		  user = User.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
		  puts auth_hash["info"]
		  user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
		  user.save
	 
		  render :text => "Hi #{user.name}! You've signed up."
		end
	end
	
	def callback
		omniauth = request.env["omniauth.auth"]
		token = omniauth['credentials']['token']
		@api = Koala::Facebook::API.new(token)
		begin
			#@graph_data = @api.get_object("/me?fields=likes.fields(name, description)")
			#objeto = "me?fields=id,name,likes.fields(events.fields(name)),friends.limit(3).fields(likes.limit(2).fields(events.limit(4).fields(name)))"
			objeto = "me?fields=id,name,likes.fields(name,description),music.fields(name,description),books.fields(name,description),games.fields(name,description),interests.fields(name,description),videos.fields(name,description)"
			@graph_data = @api.get_object(objeto)
		rescue Exception=>ex
			puts ex.message
		end
		#puts @graph_data.to_yaml;
		texto = ""
		if @graph_data["likes"]["data"]; @graph_data["likes"]["data"].each do |photo|
				texto = texto + "my like: #{photo['name']} :#{photo['description']} <br/>"
				#texto = texto + "my like: #{photo['name']} <br/>"
		end; end
		if @graph_data["music"]; @graph_data["music"]["data"].each do |photo|
				texto = texto + "my music: #{photo['name']} :#{photo['description']} <br/>"
		end; end
		if @graph_data["books"]; @graph_data["books"]["data"].each do |photo|
				texto = texto + "my books: #{photo['name']} :#{photo['description']} <br/>"
		end; end
		if @graph_data["games"]; @graph_data["games"]["data"].each do |photo|
				texto = texto + "my games: #{photo['name']} :#{photo['description']} <br/>"
		end; end
		if @graph_data["interests"]; @graph_data["interests"]["data"].each do |photo|
				texto = texto + "my interests: #{photo['name']} :#{photo['description']} <br/>"
		end; end
		if @graph_data["videos"]; @graph_data["videos"]["data"].each do |photo|
				texto = texto + "my videos: #{photo['name']} :#{photo['description']} <br/>"
		end; end
		render :text =>"#{texto} <br/>"
	end

  def failure
  	render :text => "Sorry, but you didn't allow access to our app!"
  end
  
	def destroy
		session[:user_id] = nil
		render :text => "You've logged out!"
	end
	
	def start
		@oauth= Koala::Facebook::OAuth.new(APP_ID, APP_SECRET,REDIRECT_URI)
		redirect_to @oauth.url_for_oauth_code(:permissions=>"user_likes")
#		render :text => "You've logged out!"
	end
	
	def some_method
		session[:access_token] = @oauth.get_access_token(params[:code])
		@api = Koala::Facebook::API.new(session[:access_token])
		begin
			@graph_data = @api.get_object("/me/photos")
		rescue Exception=>ex
			puts ex.message
		end
		@graph_data.each do |photo|
			puts "my photo: #{photo.name}"
		end

	end
end
