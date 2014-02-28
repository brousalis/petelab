Portal::Application.routes.draw do

  root 'site#index'

  get '/n/:n' => 'site#n', as: :n
  get '/txt'  => 'site#txt'
  get '/select'  => 'site#select'
  get '/scroll'  => 'site#scroll'

  get '/pusher/auth' => 'pusher#auth'

end
