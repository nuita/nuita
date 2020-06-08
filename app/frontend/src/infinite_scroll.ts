import { setFollowIcons } from './follow_icon';
import { setLikeButtons } from './nweets';
import { setTagButtons } from './tags';

export default function setInfiniteScroll() {
  let scroll = document.getElementById('infiniteScrollContainer');

  if (scroll) {
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

    const observer = new IntersectionObserver((entries) => {
      let morePostsUrl = new URL(location.href);

      // #infiniteScrollContainerのdata属性をクエリに乗せる
      for (const [key, value] of Object.entries(scroll.dataset)) {
        morePostsUrl.searchParams.set(key, value)
      }

      for (const e of entries) {
        if (!e.isIntersecting) continue;

        if (morePostsUrl.href) {
          fetch(morePostsUrl.href, fetchOptions).then((response) => {
            return response.text();
          }).then((partial: string) => {
            const container = scroll.parentElement
            container.removeChild(scroll);
            // なぜか表示するヌイートもうないときにresponse.text()は半角空白を返す
            if (partial && partial != " ") {
              container.insertAdjacentHTML('beforeend', partial);
              setInfiniteScroll();
              setFollowIcons();
              setLikeButtons();
              setTagButtons();
            }
          });
        }
      }
    }, observerOptions);

    observer.observe(scroll);
  }
}
