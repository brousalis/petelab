Portal::Application.routes.draw do
  root 'site#index'
  controller :site do 
    get 'master'
    get 'one'
    get 'two'
    get 'three'
    get 'slave'
    get 'screenshot'
  end 

  post '/pusher/auth' => 'pusher#auth'
end
