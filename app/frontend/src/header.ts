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
  const activeModeDetector = document.getElementById('activeModeDetector');
  const pageNavMode = activeModeDetector?.getAttribute('data-nav-mode');
  if (pageNavMode === null) {
    return;
  }

  const icon = document.getElementById(`userHeaderNav${pageNavMode}`);
  icon?.classList?.add('active');
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
