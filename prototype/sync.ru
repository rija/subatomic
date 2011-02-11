#require 'rubygems'
#require 'sinatra/async'
require 'atom/pub'
require 'sinatra/async'
require 'em-http'

class Sync < Sinatra::Base
  register Sinatra::Async
  
  aget '/callback' do
    body params['hub.challenge']
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

     EventMachine.run {
           http = EventMachine::HttpRequest.new('****/wp-app.php/posts').post(
           :head => {'authorization' => ['****', '****'],"Content-Type" => "application/atom+xml"}, 
           :body => newest_entry.to_xml)

           http.errback { p 'Uh oh'; EM.stop }
           http.callback {
             p http.response_header.status
             p http.response_header
             p http.response

           }
         }
     
  
   end
  
  
end

run Sync.new

