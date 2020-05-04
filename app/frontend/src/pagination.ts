import { setFollowIcons } from './follow_icon';
import { setLikeButtons } from './nweets';
import { setTagButtons } from './tags';

export default function setPagination() {
  let paginateContainer = document.getElementById('willPaginateContainer');

  if (paginateContainer) {
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

    let pageNumber = 2;
    let isLoading = false;

    const observer = new IntersectionObserver((entries) => {
      if (isLoading) {
        return;
      }

      isLoading = true;
      let morePostsUrl = new URL(location.href);
      morePostsUrl.searchParams.set('scroll', '1');
      morePostsUrl.searchParams.set('page', pageNumber.toString());
      pageNumber++;

      for (const e of entries) {
        if (morePostsUrl.href) {
          fetch(morePostsUrl.href, fetchOptions).then((response) => {
            return response.text();
          }).then((partial: string) => {
            let timelineContainer = document.querySelector('.nweets-list');
            // なぜか表示するヌイートもうないときにresponse.text()は半角空白を返す
            if (!partial || partial == " ") {
              observer.unobserve(document.querySelector('#willPaginateContainer'));
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

    observer.observe(document.querySelector('#willPaginateContainer'));
  } else {
    setFollowIcons();
    setLikeButtons();
    setTagButtons();
  }
}
