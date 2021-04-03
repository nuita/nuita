export function setFooterButtons() {
  const houseIcon = document.getElementById('userFooterListItemHome');
  if (houseIcon === null) {
    return;
  }

  const pathname = location.pathname;
  let navToSetActive: HTMLElement;
  if (pathname == '/') {
    navToSetActive = houseIcon;
  } else if (pathname.match('/explore')) {
    navToSetActive = document.getElementById('userFooterListItemExplore');
  } else if (pathname.match('/likes')) {
    navToSetActive = document.getElementById('userFooterListItemLikes');
  } else if (pathname.match('/users/')) {
    navToSetActive = document.getElementById('userFooterListItemProfile');
  }

  navToSetActive?.classList?.add('active');
}
