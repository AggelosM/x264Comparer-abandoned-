var url = window.location.pathname.match(/(\D\D)(\d{7})\/$/);

if (url) {
  if (url[1] == 'tt') {
    var id = '1' + url[2];
  }
  else if (url[1] == 'nm') {
    var id = '2' + url[2];
  }

  if (typeof id !== 'undefined') {
    var request = new XMLHttpRequest();
    request.addEventListener('load', function() { createForum(request) });
    request.open('GET', `https://imdbarchive.com/browserGrabber/${id}/`, true);
    request.send();
  }
}
else {
  url = window.location.pathname.match(/(\D\D)(\d{7})\/combined/);
  if (url[1] == 'tt') {
    var id = '1' + url[2];
  }
  else if (url[1] == 'nm') {
    var id = '2' + url[2];
  }

  if (typeof id !== 'undefined') {
    var request = new XMLHttpRequest();
    request.addEventListener('load', function() { createForum(request, 'tn15content') });
    request.open('GET', `https://imdbarchive.com/browserGrabber/${id}/`, true);
    request.send();
  }
}

function createForum(request, override) {
  var data = JSON.parse(request.response);
  var threads = data.m;
  var forum = document.createElement('div');
  if (override) {
    forum.className = 'headerinline';
  }
  else {
    forum.className = 'article';
  }
  forum.id = 'boardsTeaser';
  if (threads.length) {
    createBody(forum, 'Latest Posts', `${data.h}${id}/`, `Discuss ${data.n}`, ` at ${data.w} »`);
  }
  else {
    createBody(forum, 'No Posts', `${data.h}${id}/`, `Start discussing ${data.n}`, ` at ${data.w} »`);
  }
  var topics = [];
  var i = 0;
  var tbody = forum.getElementsByTagName('tbody')[0];
  for (thread in threads) {
    let parity = i++ % 2 ? 'even' : 'odd';
    var tr = createTr(parity, threads[thread]['url'], decodeHTMLEntities(threads[thread]['title']), threads[thread]['alterLink'], threads[thread]['time']);
    tbody.appendChild(tr);
  }
  if (override) {
    var elt = document.getElementById(override);
    var h3s = elt.getElementsByTagName('h3');
    var h3 = h3s[h3s.length - 1];
    h3.parentNode.insertBefore(forum, h3);
  }
  else {
    var target = document.getElementsByClassName(data.t.slice(1))[0];
    if (target) {
      target.parentNode.insertBefore(forum, target);
    }
  }
}

// http://stackoverflow.com/questions/5796718/html-entity-decode
function decodeHTMLEntities (str) {
  var element = document.createElement('div');

  if(str && typeof str === 'string') {
    // strip script/html tags
    str = str.replace(/<script[^>]*>([\S\s]*?)<\/script>/gmi, '');
    str = str.replace(/<\/?\w(?:[^"'>]|"[^"]*"|'[^']*')*>/gmi, '');
    element.innerHTML = str;
    str = element.textContent;
    element.textContent = '';
  }

  return str;
}

function createTr(parity, url, title, link, time) {
  var tr = document.createElement('tr');
  tr.className = parity;
  var titleTd = document.createElement('td');
  var titleUrl = document.createElement('a');
  titleUrl.href = url;
  titleUrl.textContent = title;
  var linkTd = document.createElement('td');
  var latestUrl = document.createElement('a');
  latestUrl.href = link;
  latestUrl.textContent = time;
  titleTd.appendChild(titleUrl);
  linkTd.appendChild(latestUrl);
  tr.appendChild(titleTd);
  tr.appendChild(linkTd);
  return tr;
}

function createBody(forum, postsText, homeLink, homeText, atText) {
  var h2 = document.createElement('h2');
  h2.textContent = 'Message Boards';
  var posts = document.createElement('span');
  posts.textContent = postsText;
  var table = document.createElement('table');
  table.className = 'boards';
  table.appendChild(document.createElement('tbody'));
  var div = document.createElement('div');
  div.className = 'see-more';
  var home = document.createElement('a');
  home.href = homeLink;
  home.textContent = homeText;
  var span = document.createElement('span');
  span.textContent = atText;
  div.appendChild(home);
  div.appendChild(span);
  forum.appendChild(h2);
  forum.appendChild(posts);
  forum.appendChild(table);
  forum.appendChild(div);
}
