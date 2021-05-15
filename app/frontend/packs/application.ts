import "core-js/stable";
import "regenerator-runtime/runtime";
import Rails from "rails-ujs";
import Turbolinks from "turbolinks";

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
import { setTagsModal } from "../src/modal";

import "../css/application.scss";

require.context('../images', true);

Rails.start();
Turbolinks.start();

window.addEventListener("turbolinks:load", (event) => {
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
  setTagsModal();
});
