export default function setRecommendButton() {
  let recommendButton = document.getElementById("buttonRenewRecommend");
  if (recommendButton) {
    recommendButton.addEventListener("click", () => {
      fetch('/links/recommend') // landingでも更新ボタン押すとR18Gとか出てくるけどまあいいでしょ・・・
        .then((response) => {
          return response.text();
        })
        .then((partial: string) => {
          let card = document.getElementById("recommendCard");
          card.textContent = "";
          card.insertAdjacentHTML("afterbegin", partial);
        });
    });
  }
}
