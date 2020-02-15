// Run this example by adding <%= javascript_pack_tag 'hello_typescript' %> to the head of your layout file,
// like app/views/layouts/application.html.erb.

// ロゴを押すとトップへ戻る
document.addEventListener('DOMContentLoaded', ():void=>{
  let topButton = document.getElementById('navbarBrandIcon');

  if(topButton){
    topButton.addEventListener('click', ():void => {
      document.body.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
      });
    })
  }
});
