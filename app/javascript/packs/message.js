var ready = function () {

    /**
     * When the send message link on our home page is clicked
     * send an ajax request to our rails app with the sender_id and
     * recipient_id
     */

    $('.start-conversation').click(function (e) {
        e.preventDefault();
        var sender_id = $(this).data('sid');
        var recipient_id = $(this).data('rip');
        chatBox.chatWith(0);
    });

    /**
     * Used to minimize the chatbox
     */

    $(document).on('click', '.toggleChatBox', function (e) {
        e.preventDefault();
       
        var id = $(this).data('cid');
        chatBox.toggleChatBoxGrowth(0);
    });

    /**
     * Used to close the chatbox
     */

    $(document).on('click', '.closeChat', function (e) {
        e.preventDefault();
        var id = $(this).data('cid');
        chatBox.close(id);
    });


    /**
     * Listen on keypress' in our chat textarea and call the
     * chatInputKey in chat.js for inspection
     */

    $(document).on('keydown', '.chatboxtextarea', function (event) {
        //var id = $(this).data('cid');
        //chatBox.checkInputKey(event, $(this), id);
        if (event.keyCode == 13) {
          $('#send-button').click()
          event.target.value = ""
          event.preventDefault()
        }
    });

    /**
     * When a conversation link is clicked show up the respective
     * conversation chatbox
     */

    $('a.conversation').click(function (e) {
        e.preventDefault();

        var conversation_id = $(this).data('cid');
        chatBox.chatWith(conversation_id);
    });


}

//$(document).ready(ready);
$(document).on("turbolinks:load", ready);