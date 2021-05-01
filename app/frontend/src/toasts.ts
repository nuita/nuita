import { Toast } from 'bootstrap';

export function setToasts() {
  const elements = document.getElementsByClassName("toast");
  Array.from(elements).forEach((t) => {
    const toast = new Toast(t);
    toast.show();
  });
}
