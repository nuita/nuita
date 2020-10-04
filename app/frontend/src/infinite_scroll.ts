import { setLikeButtons } from './nweets';
import { setTagButtons } from './tags';

function handleInfiniteScroll(scroll: HTMLElement) {
  let morePostsUrl = new URL(location.href);

  // #infiniteScrollContainerのdata属性をクエリに乗せる
  for (const [key, value] of Object.entries(scroll.dataset)) {
    morePostsUrl.searchParams.set(key, value)
  }

  const fetchOptions: RequestInit = {
    method: 'GET',
    mode: 'same-origin',
    credentials: 'same-origin',
    headers: {
      'X-Requested-With': 'XMLHttpRequest'
    }
  }

  fetch(morePostsUrl.href, fetchOptions).then((response) => {
    return response.text();
  }).then((partial: string) => {
    const container = scroll.parentElement
    container.removeChild(scroll);
    // なぜか表示するヌイートもうないときにresponse.text()は半角空白を返す
    if (partial && partial != " ") {
      container.insertAdjacentHTML('beforeend', partial);
      setInfiniteScroll();
      setLikeButtons();
      setTagButtons();
    }
  });
}

export default function setInfiniteScroll() {
  let scroll = document.getElementById('infiniteScrollContainer');

  if (scroll) {
    const observerOptions = {
      root: null,
      rootMargin: '240px',
      threshold: [1.0]
    };

    const observer = new IntersectionObserver((entries) => {
      for (const e of entries) {
        if (!e.isIntersecting) continue;
        handleInfiniteScroll(scroll);
      }
    }, observerOptions);

    observer.observe(scroll);
  }
}
