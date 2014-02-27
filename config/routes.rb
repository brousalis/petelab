Portal::Application.routes.draw do
  root 'site#index'
  controller :site do 
    get 'master'
    get 'one'
    get 'two'
    get 'three'
    get 'slave'
  end 

  post '/pusher/auth' => 'pusher#auth'
end
