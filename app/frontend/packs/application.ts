import "core-js/stable";
import "regenerator-runtime/runtime";

import setHeaderButton from "../src/header";
import fetchNotification from "../src/notification";
import setRecommendButton from "../src/recommend";
import setInfiniteScroll from "../src/infinite_scroll";
import setUserButtons from "../src/users";
import { setFollowIcons } from "../src/follow_icon";
import { setLikeButtons } from "../src/nweets";
import { setTagButtons } from "../src/tags";

window.addEventListener("turbolinks:load", (event) => {
  setHeaderButton();
  fetchNotification();
  setRecommendButton();
  setInfiniteScroll();
  setUserButtons();
  setFollowIcons();
  setLikeButtons();
  setTagButtons();
});
