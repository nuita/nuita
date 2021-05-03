export function setSettingsMenu() {
  const detector = document.getElementById('activeModeDetector');
  const itemName = detector?.getAttribute('data-settings-item');
  if (!itemName) {
    return;
  }

  const element = document.getElementById(`settingsItem${itemName}`);
  element.classList.add('active');
}
