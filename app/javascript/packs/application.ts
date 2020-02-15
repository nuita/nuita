import "core-js/stable";
import "regenerator-runtime/runtime";

import setHeaderButton from "../ts/header";
import fetchNotification from "../ts/notification";
import setRecommendButton from "../ts/recommend";
import setPagination from "../ts/pagination";
import setUserButtons from "../ts/users";

window.addEventListener("DOMContentLoaded", (event) => {
  setHeaderButton();
  fetchNotification();
  setRecommendButton();
  setPagination();
  setUserButtons();
});
