export function setFooterButtons() {
  const activeModeDetector = document.getElementById('activeModeDetector');
  if (activeModeDetector === null) {
    return;
  }

  const pageNavMode = activeModeDetector.getAttribute('data-nav-mode');
  if (pageNavMode === null) {
    return;
  }

  const icon = document.getElementById(`userFooterListItem${pageNavMode}`);
  if (icon !== null) {
    icon.classList.add('active');
  }
}
