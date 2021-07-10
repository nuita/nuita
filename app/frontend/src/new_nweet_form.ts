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
  const dateInput = <HTMLFormElement>document.getElementById('newNweetDatetimeFormInput');

  prompt.addEventListener('click', (e) => {
    e.preventDefault();

    const now = convertDateToDOMFormat(new Date());

    // ugly but effective https://stackoverflow.com/a/31665235
    const minDate = new Date(new Date().setDate(new Date().getDate() - 30));

    dateInput.value = now;
    dateInput.max = now;
    dateInput.min = convertDateToDOMFormat(minDate);

    form.classList.remove('d-none');
    prompt.classList.add('d-none');
  });

  const closeButton = document.getElementById('newNweetDatetimeFormCloseBtn');
  closeButton.addEventListener('click', (e) => {
    e.preventDefault();

    dateInput.value = null;
    dateInput.max = null;
    dateInput.min = null;
    prompt.classList.remove('d-none');
    form.classList.add('d-none');
  });
};

const convertDateToDOMFormat = (date: Date) => {
  date.setMinutes(date.getMinutes() - date.getTimezoneOffset());
  return date.toISOString().slice(0, 16);
}
