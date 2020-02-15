// ロゴを押すとトップへ戻る
export default function setHeaderButton(){
  let topButton = document.getElementById('navbarBrandIcon');

  if(topButton){
    topButton.addEventListener('click', ():void => {
      document.body.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
      });
    })
  }
}
