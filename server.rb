# coding: utf-8
require 'sinatra'
require 'json'
require './process.rb'

set :bind, '0.0.0.0'
set :port, 3001

get '/pingtest', provides: :json do
  params = JSON.parse request.body.read
  if params['id'].nil? then
    result = {error: "parameter 'id' is required"}
    code = 400
  else
    result = CucumberProcess.find(params['id'].to_i)
  end
  status code
  body result.to_json
end

post '/pingtest', provides: :json do
  params = JSON.parse request.body.read
  res = {id:params['vlan_id']}
  process = CucumberProcess.new()
  command = "pingtest " + params['vlan_id'] + " " + params['sites'].join(" ")
  process.exec(command)
  status 200
  body process.to_json
end
