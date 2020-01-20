let setIndividualFollowIcon = (event: Event) => {
  let a = <HTMLElement>event.currentTarget;
  let span = <HTMLElement>a.firstElementChild;
  let i = <HTMLElement>span.firstElementChild;

  if(span.classList.contains('unfollowable')){
    a.setAttribute('data-method', 'post');
    if(i.classList.contains('fa-exchange-alt')){
      i.classList.replace('fa-exchange-alt', 'fa-user-plus');
    }else{
      i.classList.replace('fa-user-check', 'fa-user-plus');
    }
  }else{
    a.setAttribute('data-method', 'delete');
    if(span.classList.contains('follower-true')){
      i.classList.replace('fa-user-plus', 'fa-exchange-alt');
    }else{
      i.classList.replace('fa-user-plus', 'fa-user-check');
    }
  }
  span.classList.toggle('unfollowable'); 
}

export function setFollowIcons(){
  document.querySelectorAll('.follow-icon-link').forEach((a:Element) => {
    a.addEventListener('ajax:success', setIndividualFollowIcon);
  });
};
