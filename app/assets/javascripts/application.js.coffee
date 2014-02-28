#= require jquery
#= require jquery_ujs
#= require socket.io
#= require pusher
#= require html2canvas
#= require jquery-getpath
#= require_tree .
#= require_self
#= require overlay

Pusher.log = (message) -> window.console?.log message

window.petelab = new Petelab(
  # pusher key
  '91df9bc51b1be5d235fa',

  # channel name
  'petelab',

  # auth endpoint
  'http://petelab.dev/pusher/auth',
)

$ ->
  # bonus stuff?
  $('body').append """
    <div class="petelab overlay overlay-contentpush">
      <button type="button" class="overlay-close">Close</button>
      <button class="petelab-trigger-screenshots">Get Screenshots</button>
      <ul class="petelab-screenshots"></ul>
    </div>
  """

  # handle screenshots
  $('.petelab-trigger-screenshots').on 'click', (e) ->
    e.preventDefault()
    petelab.trigger('screenshot')

  $('textarea, input, select').on 'keyup change', (e) ->
    petelab.trigger 'setValue', {path: $(this).getPath(), value: $(this).val()}

  petelab.sync()



