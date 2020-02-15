document.addEventListener('DOMContentLoaded', () => {
  var pathname:string = location.pathname;
  var element:HTMLElement;
  var matchData:string[]

  if(matchData = location.search.match(/\d{4}%2F\d{2}%2F\d{2}/)){
    element = document.getElementById('cal' + unescape(matchData[0]));
  }else{
    if (~pathname.indexOf('likes')){
      element = document.getElementById('badgeLikes');
    }else if(~pathname.indexOf('followers')){
      element = document.getElementById('badgeFollowers');
    }else if(~pathname.indexOf('followees')){
      element = document.getElementById('badgeFollowees');
    }else if(~pathname.indexOf('users')){
      element = document.getElementById('badgeNweets');
    }else{
      element = null
    }
  }

  if(element){
    element.classList.add('active');
  }
});

document.addEventListener('DOMContentLoaded', () => {
  var btn = document.getElementById('buttonUnfollow');

  if(btn){
    btn.addEventListener('click', () => {
      btn.innerText = 'フォローする';
    }, false);
    btn.addEventListener('mouseover', () => {
      btn.innerText = 'フォロー解除';
    }, false);
    btn.addEventListener('mouseout', () => {
      btn.innerText = 'フォロー中';
    }, false);
  }
});
