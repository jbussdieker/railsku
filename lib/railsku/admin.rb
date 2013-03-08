require 'sinatra'
require 'sinatra/base'

module Railsku
  class Admin < Sinatra::Base
    get '/' do
      "#{Railsku::Router.backends.collect {|be| be.name}}"
    end
  end
end
