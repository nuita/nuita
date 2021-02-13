export default function setRecommendButton() {
  const recommendButton = document.getElementById("buttonRenewRecommend");
  if (recommendButton === null) {
    return;
  }

  recommendButton.addEventListener("click", () => {
    fetch('/links/recommend')
      .then((response) => {
        return response.text();
      })
      .then((partial: string) => {
        const card = document.getElementById("recommendCard");
        card.textContent = "";
        card.insertAdjacentHTML("afterbegin", partial);
      }).catch((e) => {
        console.error(e);
      });
  });
}
