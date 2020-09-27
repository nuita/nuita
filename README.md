# What is nuita?
nuitaは射精報告SNSです。 
[https://nuita.net/](https://nuita.net/)

# 環境
- Ruby 2.6.2
- Rails 5.2.3
- MySQL 8.0.18

- 環境構築には以下の記事が役に立つかもしれません
https://scrapbox.io/nuita/Nuitaを起動するまで

## dockerでの起動方法

1. `docker-compose run --rm app bundle install && yarn install --check-files`
2. `docker-compose run --rm app bundle exec rails db:setup`
3. `docker-compose up`

# 開発方針
プルリク・イシュー・コードレビュー等々大歓迎です。
抜いて喜びます。

## panchira
- オカズのプレビュー用データ収集機能(旧`app/model/resolvers`)は[Panchira](https://github.com/nuita/panchira)へ移行しました。
- プレビュー機能に関する要望・PR等は上記レポジトリにお願いします！
