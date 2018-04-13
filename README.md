# Ruby Client for Yousign API

## Description

This client allows to use the Yousign Soap API through Ruby.

## Install

+ Clone this repository:  
    * git clone https://github.com/enerfip/yousign-api-client-ruby
+ Cd into **yousign-api-client-ruby** and execute:  
    * gem build **yousign_api.gemspec**
    * gem install **yousign_api**
+ Or if you're using Bundler, add it to your Gemfile:

`gem "yousign_api", git: "https://github.com/enerfip/yousign-api-client-ruby.git"`

## Configuration
Add this somewhere in your project code (in a Rails app for example: `app/initialisers/yousign.rb`)

```ruby
YousignApi.setup do |config|
  config.username = "my_username"
  config.password = "my_password"
  config.apikey = "my_apikey"
  config.environment = "prod" # Optional, defaults to "demo"
  config.encrypt_password = true # Optional, defaults to `false`
end
```

## Examples
You can find some examples about the way the client works in **~/examples**.  
First, run the file **connection.rb** to verify your access.  
Here, you can also set your user parameters in each ruby file.  

     * client = YousignApi::Client.new

For other examples, modify information in each of these Ruby files, then you can run these following programs.
  
     * signature_init : Initialize a signature process.
     * signature_downloadFile : Get signed files associated with a signature process from an idDemand or a token.
     * signature_details : Get information (status, name, file info) about a signature process from an idDemand or a token.
     * signature_list : Get information of all your signature processes.
     * signature_alert : Alert signers who have not signed document(s) yet.
     * signature_cancel : Cancel a signature process which is not finished yet.
     * archive : Archive document for 10 years with metadatas. Metadatas are used to find easily one (or several) archive.
     * getArchive : Get archive file identified by its iua
     * getCompleteArchive : Get complete archive file identified by its iua.
