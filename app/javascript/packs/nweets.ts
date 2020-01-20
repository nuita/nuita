let setIndividualLikeButton = (event:Event) => {
  let div = <HTMLElement>event.currentTarget;

  let anchor = <HTMLElement>div.firstElementChild;
  let icon = <HTMLElement>anchor.childNodes[0];
  let likeFlash = <HTMLElement>anchor.childNodes[1];
  let outerLatestLikedTime = <HTMLElement>anchor.childNodes[2];
  // let likeNumElement = <HTMLElement>anchor.childNodes[1];
  anchor.classList.toggle('liked');

  if(icon.classList.contains('fas')){
    icon.classList.replace('fas', 'far');
    anchor.setAttribute('data-method', 'post');
    outerLatestLikedTime.classList.remove('d-none');
    likeFlash.innerText = '';
  }else{
    icon.classList.replace('far', 'fas');
    anchor.setAttribute('data-method', 'delete');
    likeFlash.innerText = "「いいね」しました！";
    outerLatestLikedTime.classList.add('d-none');
  }
}

export function setLikeButtons(){
  document.querySelectorAll('.like-btn').forEach(function(div){
    div.addEventListener('ajax:success', setIndividualLikeButton);
  });
};
