export function setLikeButtons(){
  document.querySelectorAll('.like-btn').forEach(function(div){
    div.addEventListener('ajax:success', function(){
      var anchor = <HTMLElement>div.firstElementChild;
      var icon = <HTMLElement>anchor.childNodes[0];
      var likeFlash = <HTMLElement>anchor.childNodes[1];
      var outerLatestLikedTime = <HTMLElement>anchor.childNodes[2];
      // var likeNumElement = <HTMLElement>anchor.childNodes[1];
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
    })
  });
};

document.addEventListener('turbolinks:load', function(){
  setLikeButtons();
});
