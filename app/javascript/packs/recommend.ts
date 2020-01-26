import {setIndividualCategoryButton} from './categories'

let setRecommendCategoryButton = () => {
  document.querySelectorAll('#recommendCard .nweet-tag-link').forEach(function(div){
    div.addEventListener('ajax:success', setIndividualCategoryButton);
  });
}

document.addEventListener('turbolinks:load', () => {
  let recommendButton = document.getElementById("buttonRenewRecommend");
  if(recommendButton){
    recommendButton.addEventListener("click", () => {
      fetch('/links/recommend')
      .then((response) => {
        return response.text();
      })
      .then((partial:string) => {
        let card = document.getElementById("recommendCard");
        card.textContent = "";
        card.insertAdjacentHTML("afterbegin", partial);
        setRecommendCategoryButton();
      });
    });
  }
});
