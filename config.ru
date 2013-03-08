require ::File.expand_path('../config/environment',  __FILE__)

map "/admin" do
  run Railsku::Admin
end

run Railsku::Router
