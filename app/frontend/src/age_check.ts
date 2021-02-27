export function setAgeCheckModal() {
  const element = document.getElementById('toggleAgeCheckModalBtn');
  if (element == null) {
    return;
  }

  element.click();

  const btn = document.getElementById('setAgeCheckedBtn');
  btn.addEventListener('click', () => {
    const maxAge = 60 * 60 * 24 * 365 * 10;
    document.cookie = `age_checked=true; path=/; max-age=${maxAge}`;
  });
}
