export function setNewNweetForm() {
  setTextCount();
  setDatetimeForm();
}

const setTextCount = () => {
  const textarea = document.getElementById('newNweetFormTextarea');
  if (textarea === null || !(textarea instanceof HTMLTextAreaElement)) {
    return;
  }

  textarea.addEventListener('input', () => {
    // ↓絵文字に配慮したコード。textboxの仕様を変えられたら使う
    // const count = [...textarea.value].length.toString();
    const count = textarea.value.length.toString();

    const lengthCountDiv = document.getElementById('nweetFormBottomTextLengthCount');
    lengthCountDiv.innerText = count;
  });
}

const setDatetimeForm = () => {
  const prompt = document.getElementById('newNweetDatetimePrompt');
  if (prompt === null || prompt === undefined) {
    return;
  }

  const form = document.getElementById('newNweetDatetimeFormWrapper');

  prompt.addEventListener('click', (e) => {
    e.preventDefault();

    form.classList.remove('d-none');
    prompt.classList.add('d-none');
  });

  const closeButton = document.getElementById('newNweetDatetimeFormCloseBtn');
  closeButton.addEventListener('click', (e) => {
    e.preventDefault();

    prompt.classList.remove('d-none');
    form.classList.add('d-none');
  });
};
