// ロゴを押すとトップへ戻る
export function setHeaderButton() {
  setTopButton();
  setNavButton();
}

function setTopButton() {
  const topButton = document.getElementById('navbarBrandIcon');
  if (topButton === null) {
    return;
  }

  topButton.addEventListener('click', (event): void => {
    event.preventDefault();
    document.body.scrollIntoView({
      behavior: 'smooth',
      block: 'start'
    });
  });
}

function setNavButton() {
  const pathname: string = location.pathname;
  const userNavItems = document.getElementsByClassName("user-home-nav");
  if (userNavItems.length === 0) {
    return;
  }

  const homeNav = document.getElementById("homeNav");
  const exploreNav = document.getElementById("exploreNav")
  const notificationsNav = document.getElementById("notificationsNav");

  Array.from(userNavItems).forEach(e => {
    e.classList.remove("active")
  });

  if (pathname == "/") {
    homeNav.classList.add("active");
  } else if (pathname == "/explore") {
    exploreNav.classList.add("active");
  } else if (pathname == "/notifications") {
    notificationsNav.classList.add("active");
  } else {
    notificationsNav.classList.remove("active");
  }
}

// スクロール時にヘッダーが隠れる
export function hideHeaderWhileScrolling() {
  if (window.innerWidth >= 992) {
    return;
  }

  const navbar = document.getElementById("NavbarScrollable");
  if (navbar === null) {
    return;
  }

  let lastOffset = 0;
  window.addEventListener("scroll", () => {
    const nowOffset = window.pageYOffset;

    if (nowOffset > 0 && nowOffset >= lastOffset) {
      navbar.classList.add("navbar-faded-out");
    } else {
      navbar.classList.remove("navbar-faded-out");
    }

    lastOffset = nowOffset;
  });
}
