import "core-js/stable";
import "regenerator-runtime/runtime";

import { setHeaderButton, hideHeaderWhileScrolling } from "../src/header";
import fetchNotification from "../src/notification";
import setRecommendButton from "../src/recommend";
import setInfiniteScroll from "../src/infinite_scroll";
import setUserButtons from "../src/users";
import { setLikeButtons } from "../src/nweets";
import { setTagButtons } from "../src/tags";
import { setAgeCheckModal } from "../src/age_check";

import "bootstrap";
import "../css/application.scss";

require.context('../images', true)

window.addEventListener("DOMContentLoaded", (event) => {
  setHeaderButton();
  hideHeaderWhileScrolling();
  fetchNotification();
  setRecommendButton();
  setInfiniteScroll();
  setUserButtons();
  setLikeButtons();
  setTagButtons();
  setAgeCheckModal();
});
