class window.Petelab
  constructor: (@key, @channelName, @authEndpoint) ->
    @isClient = (window.location.hash == '#client')

    @pusher = new Pusher @key, authTransport: 'jsonp', authEndpoint: @authEndpoint
    @pusher.connection.bind 'state_change', (states) => @_setState(states)
    
    @channel  = @pusher.subscribe "private-#{@channelName}"

    for event, handler of @events
      @channel.bind "client-#{event}", handler

  _setState: (states) ->
    indicators =
      initialized: '⋯'
      connecting: '⋯'
      connected: '✓'
      disconnected: '✗'
      unavailable: '✗'

    document.title = document.title.replace(new RegExp("^\\\[#{indicators[states.previous]}\\\] +"), '')
    document.title = "[#{indicators[states.current]}] #{document.title}"

    $('.petelab, .petelab-state').removeClass(states.previous).addClass(states.current)

  events:
    navigate: (data) ->
      if window.location.href == data.url
        window.location.reload()
      else
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
              height: $(window).height()
              width: $(window).width()

    screenshotDone: (data) ->
      result = UAParser(data.agent)
      browser = result.browser
      device = if result.device.vendor then "<span>#{result.device.vendor} #{result.device.model}</span>" else ""
      os = "#{result.os.name} #{result.os.version}" 
      engine = result.engine

      $('.petelab-screenshots').append """
        <li>
          <div class="data">
            <span>#{browser.name} #{browser.version}</span>
            #{device}
            <span>#{os}</span>
            <span>#{engine.name}</span>
            <span>#{data.width}x#{data.height}</span>
          </div>
          <div class="image">
            <a href="#{data.link}" target="_blank">
              <img class='img' src='#{data.link}' alt='#{data.agent}'>
            </a>
          </div>
        </li>
      """

    setValue: (data) ->
      $(data.path).val(data.value)

    scroll: (data) ->
      if petelab.isClient
        if data.scrollTop
          $('body').stop().animate(scrollTop: data.scrollTop, 100)
        else if data.scrollTopPercentage
          $('body').stop().animate(scrollTop: ($(document).height() * data.scrollTopPercentage), 100)


  sync: ->
    # get everyone on the same page
    if @isClient
      $('.petelab-client-hidden').hide()
    else
      petelab.channel.bind 'pusher:subscription_succeeded', =>
        @trigger 'navigate', url: (window.location.href.replace(/#.*$/, '') + '#client')

  trigger: (event, data = {}, callback) ->
    if @channel.trigger "client-#{event}", data
      callback

    if callback?
      setTimeout (=> callback.apply(@)), 1000
