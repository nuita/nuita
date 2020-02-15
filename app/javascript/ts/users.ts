export default function setUserInfoButtons(){
  /* 左カラムの/users/以下で白抜きになるボタンの設定 */
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

  /* フォローボタンの設定 */
  var followBtn = document.getElementById('buttonUnfollow');

  if(followBtn){
    followBtn.addEventListener('click', () => {
      followBtn.innerText = 'フォローする';
    }, false);
    followBtn.addEventListener('mouseover', () => {
      followBtn.innerText = 'フォロー解除';
    }, false);
    followBtn.addEventListener('mouseout', () => {
      followBtn.innerText = 'フォロー中';
    }, false);
  }
}
