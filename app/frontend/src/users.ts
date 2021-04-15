export default function setUserInfoButtons() {
  /* 左カラムの/users/以下で白抜きになるボタンの設定 */
  var pathname: string = location.pathname;
  var element: HTMLElement;
  var matchData: string[]

  if (matchData = location.search.match(/\d{4}%2F\d{2}%2F\d{2}/)) {
    element = document.getElementById('cal' + unescape(matchData[0]));
  } else {
    if (~pathname.indexOf('likes')) {
      element = document.getElementById('userInfoLikes');
    } else if (~pathname.indexOf('followers')) {
      element = document.getElementById('userInfoFollowers');
    } else if (~pathname.indexOf('followees')) {
      element = document.getElementById('userInfoFollowees');
    } else if (~pathname.indexOf('users')) {
      element = document.getElementById('userInfoNweets');
    } else {
      element = null
    }
  }

  if (element) {
    element.classList.add('active');
  }

  setUnfollowBtn();
}

function setUnfollowBtn() {
  /* フォローボタンの設定 */
  const followBtn = document.getElementById('buttonUnfollow');
  if (followBtn === null) {
    return;
  }

  // i18nに対応できないのでどうにかする
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
