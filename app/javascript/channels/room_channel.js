import consumer from "./consumer"

consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("******************************");
    console.log("Connected to the room!");
    console.log("******************************");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("data received")
    $('#messages-table').append(
      '<div class="message">' +
      data.sname + ":" + data.content + 
      '</div>')
  	console.log(data)
  }
});

// press enter key to send message
/*$(document).on('turbolinks:load', function () {
  $('.chatboxinput').on('keydown', function(event) {
    if (event.keyCode == 13) {
      $('input').click()
      event.target.value = ""
      event.preventDefault()
      console.log(event)
    }
  })
})*/

  

