import "core-js/stable";
import "regenerator-runtime/runtime";

import setHeaderButton from "../src/header";
import fetchNotification from "../src/notification";
import setRecommendButton from "../src/recommend";
import setInfiniteScroll from "../src/infinite_scroll";
import setUserButtons from "../src/users";

window.addEventListener("DOMContentLoaded", (event) => {
  setHeaderButton();
  fetchNotification();
  setRecommendButton();
  setInfiniteScroll();
  setUserButtons();
});
