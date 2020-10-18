// ロゴを押すとトップへ戻る
export function setHeaderButton() {
  let topButton = document.getElementById('navbarBrandIcon');

  if (topButton) {
    topButton.addEventListener('click', (event): void => {
      event.preventDefault();
      document.body.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
      });
    })
  }

  let pathname: string = location.pathname;
  let userNavItems = document.getElementsByClassName("user-home-nav")

  if (userNavItems) {
    let homeNav = document.getElementById("homeNav");
    let exploreNav = document.getElementById("exploreNav")
    let notificationsNav = document.getElementById("notificationsNav");

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
}

// スクロール時にヘッダーが隠れる
export function hideHeaderWhileScrolling() {
  let navbar = document.getElementById("Navbar");

  window.addEventListener("scroll", () => {
    if (window.pageYOffset > window.innerHeight) {
      navbar.classList.add("navbar-faded-out");
    }

    t = window.setTimeout(() => {
      navbar.classList.remove("navbar-faded-out");
    }, 2000)
  });
}
