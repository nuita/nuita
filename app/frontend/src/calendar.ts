import { Tooltip } from 'bootstrap';

export default function setCalendar() {
  const tooltips = document.getElementsByClassName('has-tooltip');
  if (tooltips.length == 0) {
    return;
  }

  const tooltipTriggerList = [].slice.call(tooltips);
  return tooltipTriggerList.map((e) => {
    return new Tooltip(e);
  });
}
