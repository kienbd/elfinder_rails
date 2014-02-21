class HomeController < ApplicationController

 def index


 end
 def elfinder
    h, r = ElFinder::Connector.new(
      :root => File.join(Rails.public_path, 'system', 'elfinder'),
      :url => '/system/elfinder',
       :perms => {
         /^(Welcome|README)$/ => {:read => true, :write => true, :rm => false},
         '.' => {:read => true, :write => true, :rm => false}, # '.' is the proper way to specify the home/root directory.
         /^test$/ => {:read => true, :write => true, :rm => false},
         'logo.png' => {:read => true},
         /\.txt$'/ => {:read =>true,:write => false}
       },
       :extractors => {
         'application/zip' => ['unzip', '-qq', '-o'], # Each argument will be shellescaped (also true for archivers)
         'application/x-gzip' => ['tar', '-xzf'],
       },
       :archivers => {
         'application/zip' => ['.zip', 'zip', '-qr9'], # Note first argument is archive extension
         'application/x-gzip' => ['.tgz', 'tar', '-czf'],
         },

    ).run(params)

    headers.merge!(h)

    render (r.empty? ? {:nothing => true} : {:text => r.to_json}), :layout => false
  end



end
