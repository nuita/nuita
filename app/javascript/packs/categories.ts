let setIndividualCategoryButton = (event:Event) => {
  let a = <HTMLElement>event.currentTarget;

  let badge = <HTMLElement>a.firstChild;
  let i = <HTMLElement>badge.childNodes[2].firstChild;

  if(a.getAttribute('data-method') == 'post'){
    a.setAttribute('data-method', 'delete');
    i.classList.replace('fa-plus', 'fa-times');
    badge.classList.add('active');
  }else{
    a.setAttribute('data-method', 'post');
    i.classList.replace('fa-times', 'fa-plus');
    badge.classList.remove('active');
  }
}

export function setCategoryButtons(){
  document.querySelectorAll('.tag-link').forEach(function(div){
    div.addEventListener('ajax:success', setIndividualCategoryButton);
  });
};
