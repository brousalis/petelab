Pusher.log = (message) ->
  window.console?.log message
 
pusher = new Pusher('91df9bc51b1be5d235fa')
channel = pusher.subscribe('private-test_channel')

$ ->
  channel.bind 'client-navigate', (data) ->
    window.location = data.url

  $(document).on 'click', 'a', (e) ->
    e.preventDefault()

    channel.trigger 'client-navigate', url: $(this).attr('href')

    setTimeout (=> window.location = $(this).attr('href')), 500
