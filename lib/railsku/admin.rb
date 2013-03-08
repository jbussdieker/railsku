require 'sinatra'
require 'sinatra/base'

module Railsku
  class Admin < Sinatra::Base
    get '/' do
      "#{Railsku::Router.backends}"
    end
  end
end
