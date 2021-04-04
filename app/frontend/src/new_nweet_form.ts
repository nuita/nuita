export function setNewNweetForm() {
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
