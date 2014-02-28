#= require jquery
#= require jquery_ujs
#= require socket.io
#= require pusher
#= require html2canvas
#= require jquery-getpath
#= require jquery-scrollstop
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
    <button id="petelab-trigger" type="button">
      <span class="petelab-state"></span>
      <span class="petelab-client-hidden">PETELAB</span>
    </button>
  """

  # handle screenshots
  $('.petelab-trigger-screenshots').on 'click', (e) ->
    e.preventDefault()
    petelab.trigger('screenshot')

  $('textarea, input, select').on 'keyup change', (e) ->
    petelab.trigger 'setValue', {path: $(this).getPath(), value: $(this).val()}

  $('textarea, input, select').filter(':visible:first').focus()

  unless petelab.isClient
    $(window).on 'scrollstop', ->
      petelab.trigger 'scroll', scrollTopPercentage: ($(window).scrollTop() / $(document).height())

  petelab.sync()



