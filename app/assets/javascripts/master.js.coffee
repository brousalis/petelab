Pusher.log = (message) ->
  window.console?.log message
 

class Petelab
  constructor: (@key, @channel_name) ->
    @pusher = new Pusher @key
    @channel = @pusher.subscribe @channel_name

    for event, handler of @_events
      @channel.bind "client-#{event}", handler

  _trigger: (event, data = {}, callback) ->
    @channel.trigger "client-#{event}", data

    if callback?
      setTimeout (=> callback()), 1000

  _events:
    navigate: (data) ->
      window.location = data.url

    screenshot: (data) ->
      html2canvas document.body, onrendered: (canvas) ->
        authorization = 'Client-ID 763ecb3480ce8c4'

        $.ajax
          url: "https://api.imgur.com/3/image"
          method: "POST"
          headers:
            Authorization: authorization
            Accept: "application/json"

          data:
            image: canvas.toDataURL('image/png').replace('data:image/png;base64', '')
            type: 'base64'

          success: (result) ->
            debugger

  navigate: (url, callback) ->
    @_trigger 'navigate', {url: url}, callback

  screenshot: ->
    @_trigger 'screenshot'

    
    return
$ ->
  window.petelab = new Petelab(
    '91df9bc51b1be5d235fa',
    'private-petelab'
  )

  $(document).on 'click', 'a', (e) ->
    e.preventDefault()

    petelab.navigate(
      $(this).attr('href'),
      (=> window.location = $(this).attr('href'))
    )


  $('.screenshot').on 'click', (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()
    petelab.screenshot()
