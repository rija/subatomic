require 'atom/pub'
require 'sinatra/async'
require 'em-http'

class Sync < Sinatra::Base
  register Sinatra::Async
  
  @@config = YAML.load_file(Dir.pwd+'/prototype/config.yml')
  
  
  get '/info' do
    @@config.each do |k,v|
       "#{k}: #{v}\n"
    end

  end
  
  aget '/callback' do
    
    
    
    body params['hub.challenge']
  end
  
  
  aget '/subscribe' do
    
    origin_feed = @@config["source"]["feed"]
    callback = @@config["hub"]["callback"]
    token = @@config["hub"]["token"]
      #   
      # EM.run {
      #   http = EM::HttpRequest.new('http://localhost:8080').post(:body => {'hub.callback' => callback, 
      #                                   'hub.topic' => origin_feed, 
      #                                   'hub.verify' => 'sync',
      #                                   'hub.mode' => 'subscribe',                                
      #                                   'hub.verify_token' => token})
      #                                   
      #   http.errback { p 'Error while trying to subscribe'; EM.stop }
      #   http.callback {
      #     p http.response_header.status
      #     p http.response_header
      #     p http.response
      # 
      #   }
      # }
      # 
      body "Success"
  end
  
  apost '/callback' do
    
   # retrieve data
   atomfeed = request.body.read 
   # parse atom
   feed = Atom::Feed.load_feed(atomfeed)
   # keep newest post
   newest_entry = feed.entries.first
   # remove id
   newest_entry.id =nil
   # async publish to blog api

     EM.run {
           http = EM::HttpRequest.new('http://oldblog.pommetab.com/wp-app.php/posts').post(
           :head => {'authorization' => ['rmenage', 'P4p0t5ur5p'],"Content-Type" => "application/atom+xml"}, 
           :body => newest_entry.to_xml)

           http.errback { p 'Error while pushing atom'; EM.stop }
           http.callback {
             p http.response_header.status
             p http.response_header
             p http.response

           }
         }
     
  
   end
  
  
end