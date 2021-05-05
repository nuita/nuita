// sidesectionのモーダルはposition: fixedの親要素の下にあるので、
// モーダル表示時にだけbodyの直下にモーダル本体を移すことで問題に対処する
export function setTagsModal() {
  const buttons = document.getElementsByClassName('edit-modal-toggle-btn');
  Array.from(buttons).forEach((btn) => {
    btn.addEventListener('click', () => {
      const target = btn.getAttribute('data-bs-target');
      const modal = document.getElementById(target.slice(1));

      document.body.appendChild(modal);
    });
  });
}
