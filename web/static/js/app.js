import {Socket, LongPoller} from "phoenix"

class App {
  static init(){

    let socket = new Socket("ws://" + location.host +  "/ws")
    socket.connect()

    let $status = $("#status")
    let $messages = $("#messages")
    let $input = $("#message-input")
    let $username = $("#username")
    let $user_count = $("#user_count")
    let messages = document.getElementById("messages")

    socket.onClose( e => console.log("CLOSE", e))

    socket.join("rooms:lobby", {})
      .receive("ignore", () => console.log("auth error"))
      .receive("ok", chan => {
        chan.onError(e => console.log("Something went wrong", e))
        chan.onClose(e => console.log("channel closed", e))

        $input.off("keypress").on("keypress", e => {
          if(e.keyCode === 13 && $input.val() !== "") {
            chan.push("new:msg", {user: $username.val(), body: $input.val()})
            $input.val("")
          }
        })

        chan.on("new:msg", msg => {
          $messages.append(this.messageTemplate(msg))
          messages.scrollTop = messages.scrollHeight
        })

        chan.on("user:count", msg => {
          $user_count.html(this.countTemplate(msg))
        })

      })
      .after(10000, () => console.log("Connection interruption"))

      $(".nav a").on("click", function(){
         $(".nav").find(".active").removeClass("active");
         $(this).parent().addClass("active");
      });

  }

  static sanitize(html) { return $("<div/>").text(html).html() }

  static messageTemplate(msg) {
    let username = this.sanitize(msg.user || "anonymous")
    let body = this.sanitize(msg.body)

    return (`<p><a href='#'>[${username}]</a>&nbsp; ${body}</p>`)
  }

  static countTemplate(msg){
    return (`<p>User Count: <b>${msg.count}</b></p>`)
  }
}

$( () => App.init() )

export default App
