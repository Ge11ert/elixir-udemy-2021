import { Socket } from "phoenix";

function createSocket(topicId) {
  const socket = new Socket("/socket", {params: {token: window.userToken}})

  socket.connect();

// Now that you are connected, you can join channels with a topic:
  const channel = socket.channel(`comments:${topicId}`, {});

  channel.join()
    .receive("ok", resp => { renderComments(resp.comments) })
    .receive("error", resp => { console.log("Unable to join", resp) });

  channel.on(`comments:${topicId}:new`, resp => { renderComment(resp.comment); });

  document.querySelector('.comment-submit-button').addEventListener('click', () => {
    const content = document.querySelector('textarea').value;

    channel.push('comment:add', { content });
  });
}

function renderComments(comments) {
  const elements = comments.map(getCommentTemplate);

  document.querySelector('.collection').innerHTML = elements.join('');
}

function renderComment(comment) {
  const element = getCommentTemplate(comment);

  document.querySelector('.collection').innerHTML += element;
}

function getCommentTemplate(comment) {
  return `<li class="collection-item">${comment.content}</li>`
}

window.createSocket = createSocket;
