#require 'rubygems'
#require 'sinatra/async'
require 'atom/pub'
require 'sinatra/async'
require 'em-http'

class Sync < Sinatra::Base
  register Sinatra::Async
  
  VERIFY_TOKEN = "4937!thjg"
  
  aget '/callback' do
    
    #check VERIFY_TOKEN, return bad request if no match
    
    body params['hub.challenge']
  end
  
  
  aget '/subscribe' do
    
    origin_feed = "http://pommetab.com/feeds/atom/"
    callback = "http://localhost:3000/callback"
    
    EM.run {
      http = EM::HttpRequest.new('localhost:8080').post(:body => {'hub.callback' => callback, 
                                      'hub.topic' => origin_feed, 
                                      'hub.verify' => 'sync',
                                      'hub.mode' => 'subscribe',                                
                                      'hub.verify_token' => VERIFY_TOKEN})
                                      
      http.errback { p 'Error while trying to subscribe'; EM.stop }
      http.callback {
        p http.response_header.status
        p http.response_header
        p http.response

      }
    }
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
           http = EM::HttpRequest.new('****/wp-app.php/posts').post(
           :head => {'authorization' => ['****', '****'],"Content-Type" => "application/atom+xml"}, 
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

run Sync.new

