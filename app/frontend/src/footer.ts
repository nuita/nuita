export function setFooterButtons() {
  const activeModeDetector = document.getElementById('activeModeDetector');
  const pageNavMode = activeModeDetector?.getAttribute('data-nav-mode');
  if (pageNavMode === null) {
    return;
  }

  const icon = document.getElementById(`userFooterListItem${pageNavMode}`);
  icon?.classList?.add('active');
}
