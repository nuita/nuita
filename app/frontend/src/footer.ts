// activeにする要素のIDを直接追加すればいいじゃんと思ったけど、
// 同じページでactiveになる要素がnavbarとuser-footerの2つあったりするので、
// あえて別々のコードベースでactive処理を行う（もっといい方法あるかも？）
export function setFooterButtons() {
  const activeModeDetector = document.getElementById('activeModeDetector');
  const pageNavMode = activeModeDetector?.getAttribute('data-nav-mode');
  if (pageNavMode === null) {
    return;
  }

  const icon = document.getElementById(`userFooterListItem${pageNavMode}`);
  icon?.classList?.add('active');
}
