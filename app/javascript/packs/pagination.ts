document.addEventListener('turbolinks:load', function(){
  let paginateContainer = document.getElementById('willPaginateContainer');

  if(paginateContainer){
    const fetchOptions:RequestInit = {
      method: 'GET',
      mode: 'same-origin',
      credentials: 'same-origin',
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      }
    }

    const observerOptions = {
      root: null,
      rootMargin: '120px',
      threshold: [1.0]
    };

    let pageNumber = 1;

    const observer = new IntersectionObserver((entries) => {
      let morePostsUrl = new URL(location.href);
      morePostsUrl.searchParams.set('scroll', '1');
      morePostsUrl.searchParams.set('page', pageNumber.toString());
      pageNumber++;

      for(const e of entries){
        if(morePostsUrl.href){
          fetch(morePostsUrl.href, fetchOptions).then((response) => {
            return response.text();
          }).then((partial:string) => {
            let timelineContainer = document.querySelector('.nweets-list');
            // なぜか表示するヌイートもうないときにresponse.text()は半角空白を返す
            if(!partial || partial == " "){
              observer.unobserve(document.querySelector('#willPaginateContainer'));
            }else{
              timelineContainer.insertAdjacentHTML('beforeend', partial);
            }
          });
        }
      }
    }, observerOptions);

    observer.observe(document.querySelector('#willPaginateContainer'));
  }
});
