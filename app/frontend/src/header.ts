// ロゴを押すとトップへ戻る
export default function setHeaderButton() {
  let topButton = document.getElementById('navbarBrandIcon');

  if (topButton) {
    topButton.addEventListener('click', (): void => {
      document.body.scrollIntoView({
        behavior: 'smooth',
        block: 'start'
      });
    })
  }

  let pathname: string = location.pathname;
  let homeNav = document.getElementById("home-nav");
  let notificationsNav = document.getElementById("notifications-nav");

  if (homeNav && notificationsNav) {
    if (pathname == "/") {
      homeNav.classList.add("active");
      notificationsNav.classList.remove("active");
    } else if (pathname == "/notifications") {
      homeNav.classList.remove("active");
      notificationsNav.classList.add("active");
    } else {
      homeNav.classList.remove("active");
      notificationsNav.classList.remove("active");
    }
  }
}
