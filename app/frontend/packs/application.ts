import "core-js/stable";
import "regenerator-runtime/runtime";
import Rails from "rails-ujs";

import { setHeaderButton, hideHeaderWhileScrolling } from "../src/header";
import { setFooterButtons } from "../src/footer";
import fetchNotification from "../src/notification";
import setRecommendButton from "../src/recommend";
import setInfiniteScroll from "../src/infinite_scroll";
import setUserButtons from "../src/users";
import setCalendar from "../src/calendar";
import { setTagButtons } from "../src/tags";
import { setAgeCheckModal } from "../src/age_check";
import { setNewNweetForm } from "../src/new_nweet_form";
import { setSettingsMenu } from "../src/settings";
import { setToasts } from "../src/toasts";

import "../css/application.scss";

require.context('../images', true);

Rails.start();

window.addEventListener("DOMContentLoaded", (event) => {
  setHeaderButton();
  setFooterButtons();
  hideHeaderWhileScrolling();
  fetchNotification();
  setRecommendButton();
  setInfiniteScroll();
  setUserButtons();
  setTagButtons();
  setAgeCheckModal();
  setCalendar();
  setNewNweetForm();
  setSettingsMenu();
  setToasts();
});
