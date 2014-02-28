#= require jquery
#= require jquery_ujs
#= require socket.io
#= require pusher
#= require html2canvas
#= require_tree .
#= require_self


Pusher.log = (message) -> window.console?.log message

window.petelab = new Petelab('91df9bc51b1be5d235fa', 'private-petelab', 'http://petelab.dev/pusher/auth')

$ ->
  # bonus stuff?
  $('body').append """
    <div class="petelab">
      <button class="petelab-trigger-screenshots">screenshot</button>
      <ul class="petelab-screenshots"></ul>
    </div>
  """

  # handle screenshots
  $('.petelab-trigger-screenshots').on 'click', (e) ->
    e.preventDefault()
    petelab.trigger('screenshot')

  petelab.sync()



