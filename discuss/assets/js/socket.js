import { Socket } from "phoenix";

function createSocket(topicId) {
  const socket = new Socket("/socket", {params: {token: window.userToken}})

  socket.connect();

// Now that you are connected, you can join channels with a topic:
  const channel = socket.channel(`comments:${topicId}`, {});

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) });

  document.querySelector('.comment-submit-button').addEventListener('click', () => {
    const content = document.querySelector('textarea').value;

    channel.push('comment:add', { content });
  });
}

window.createSocket = createSocket;
