App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    current_user_id = Window.current_user_id
    a = $(data['message'])
    if current_user_id == data['user_id']
      a.addClass("user-message")
    $('#messages').append a

  speak: (message) ->
    @perform 'speak', message: message

