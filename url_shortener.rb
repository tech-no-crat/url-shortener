require 'sinatra'
require 'redis'
require 'haml'
require 'coffee_script'
require 'sass'
require 'yaml'

configure do
  CONFIG = YAML.load_file('config.yaml')
  REDIS = Redis.new(CONFIG['redis'])
end

def save(id, link)
  if (id =~ /^[a-zA-Z0-9\-_]*$/) != 0 or id.length<3 or not find(id).nil?
    "Error: id invalid or already in use"
  elsif link.length < 3 or not link =~ %r{\Ahttps?://}
    "Error: invalid link"
  else 
    if REDIS.set(id, link) == "OK"
      status 201 # Created
      "OK: #{CONFIG['domain']}/#{id}"
    else
      status 500 # Internal Server Error
      "Error: could not save to Redis"
    end
  end
end

def find(id)
  REDIS.get id
end

get "/" do
  erb :new
end

get "/:id" do |id|
  link = find(id)
  if link
      redirect link
  else
    status 404
    "Error: Link not found."
  end
end

post "/" do
  id = params[:id]
  link = params[:link]
  save(id, link)
end
