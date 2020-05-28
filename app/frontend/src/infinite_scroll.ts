import { setFollowIcons } from './follow_icon';
import { setLikeButtons } from './nweets';
import { setTagButtons } from './tags';

export default function setInfiniteScroll() {
  let container = document.getElementById('infiniteScrollContainer');

  if (container) {
    const fetchOptions: RequestInit = {
      method: 'GET',
      mode: 'same-origin',
      credentials: 'same-origin',
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      }
    }

    const observerOptions = {
      root: null,
      rootMargin: '240px',
      threshold: [1.0]
    };

    let isLoading = false;

    const observer = new IntersectionObserver((entries) => {
      if (isLoading) {
        return;
      }

      isLoading = true;
      let morePostsUrl = new URL(location.href);
      const lastNweet = document.querySelector('.nweets-list').lastElementChild;
      morePostsUrl.searchParams.set('before', lastNweet.id.slice(5));

      for (const e of entries) {
        if (morePostsUrl.href) {
          fetch(morePostsUrl.href, fetchOptions).then((response) => {
            return response.text();
          }).then((partial: string) => {
            let timelineContainer = document.querySelector('.nweets-list');
            // なぜか表示するヌイートもうないときにresponse.text()は半角空白を返す
            if (!partial || partial == " ") {
              observer.unobserve(document.querySelector('#infiniteScrollContainer'));
            } else {
              timelineContainer.insertAdjacentHTML('beforeend', partial);
            }
          });
        }
      }
      setFollowIcons();
      setLikeButtons();
      setTagButtons();

      isLoading = false;
    }, observerOptions);

    observer.observe(document.querySelector('#infiniteScrollContainer'));
  } else {
    setFollowIcons();
    setLikeButtons();
    setTagButtons();
  }
}
