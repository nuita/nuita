// 新しく投稿するときにタグつけるやつ (JSでhidden_fieldの値変える)
let setIndividualToggleTagButton = (event: Event) => {
  let a = <HTMLElement>event.currentTarget;
  let field = <HTMLElement>a.lastChild;

  let n = parseInt(field.getAttribute('value'));
  field.setAttribute('value', (1 - n).toString());
  console.log(1 - n);

  let badge = <HTMLElement>a.firstChild;
  let i = <HTMLElement>badge.childNodes[2].firstChild;

  if (i.classList.contains('fa-plus')) {
    i.classList.replace('fa-plus', 'fa-times');
  } else {
    i.classList.replace('fa-times', 'fa-plus');
  }

  badge.classList.toggle('active');
};

export function setTagButtons() {
  document.querySelectorAll('.toggle-tag-link').forEach(function (div) {
    div.addEventListener('click', setIndividualToggleTagButton);
  });
};
