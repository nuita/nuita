export function setAgeCheckModal() {
  const element = document.getElementById('toggleAgeCheckModalBtn');
  if (element == null) {
    return;
  }

  element.click();

  const btn = document.getElementById('setAgeCheckedBtn');
  btn.addEventListener('click', () => {
    document.cookie = 'age_checked= 1';
  });
}
