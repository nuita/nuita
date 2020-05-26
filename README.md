# What is nuita?
nuitaは射精報告SNSです。 
[https://nuita.net/](https://nuita.net/)

# 環境
- Ruby 2.6.2
- Rails 5.2.3
- MySQL 8.0.18

- 環境構築には以下の記事が役に立つかもしれません
https://scrapbox.io/nuita/Nuitaを起動するまで

# 開発方針
プルリク・イシュー・コードレビュー等々大歓迎です。
抜いて喜びます。

## Nuita_2
- RailsをAPIサーバー化し、フロントエンドをReactで動かすプロジェクトが進行中です。
  - 作業ブランチ: [nuita_2](https://github.com/nuita/nuita/tree/nuita_2)
  - リリースできるようになった段階でmasterへと移します。
- このため、masterブランチにあるビュー層・コントローラー層のソースコードは今後大部分が切り捨てられます。PRとか書かないほうがいいかも
- nuita_2ブランチへのPRは大募集中です！

## panchira
- オカズのカード用データ収集機能(現`app/model/resolvers`)はgemへの切り出し作業が進行中です。
  - レポジトリ: [panchira](https://github.com/nuita/panchira)
- panchiraがv1.0.0をリリースした段階でNuitaのresolversは削除し、Panchiraを利用する形に変わります。
- Resolversに関するPR・イシューは[panchira](https://github.com/nuita/panchira)へ！
