Pusher.log = (message) ->
  window.console?.log message
 

class Petelab
  constructor: (@key, @channel_name) ->
    @pusher = new Pusher @key
    @channel = @pusher.subscribe @channel_name

    @pusher.connection.bind 'state_change', (states) => @setState(states)


    for event, handler of @_events
      @channel.bind "client-#{event}", handler

  setState: (states) ->
    indicators =
      initialized: '⋯'
      connecting: '⋯'
      connected: '✓'
      disconnected: '✗'

    document.title = document.title.replace(new RegExp("^\\\[#{indicators[states.previous]}\\\] +"), '')
    document.title = "[#{indicators[states.current]}] #{document.title}"

  trigger: (event, data = {}, callback) ->
    @channel.trigger "client-#{event}", data

    if callback?
      setTimeout (=> callback.apply(@)), 1000

  _events:
    navigate: (data) ->
      window.location = data.url

    screenshot: (data) ->
      html2canvas document.body, onrendered: (canvas) =>
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

          success: (result) =>
            petelab.trigger 'screenshotDone', 
              link: result.data.link
              agent: navigator.userAgent
              height: screen.height
              width: screen.width
              

    screenshotDone: (data) ->
      $('#screenshots').append("<li><img src='#{data.link}'></li>")


window.petelab = new Petelab('91df9bc51b1be5d235fa', 'private-petelab')


$ ->
  $(document).on 'click', 'a', (e) ->
    e.preventDefault()

    petelab.trigger 'navigate',
      url: $(this).attr('href'),
      (=> window.location = $(this).attr('href'))

  $('.screenshot').on 'click', (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()

    petelab.trigger('screenshot')
