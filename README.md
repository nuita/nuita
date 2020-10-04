[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Testing](https://github.com/nuita/nuita/workflows/Testing/badge.svg)
![Last Commit](https://img.shields.io/github/last-commit/nuita/nuita)

# Nuita
<img src="https://nuita.s3-ap-northeast-1.amazonaws.com/green.png" alt="Nuita">

NuitaはRuby on Rails製の射精報告SNSです。

[https://nuita.net/](https://nuita.net/)

# 環境構築
## ネイティブ
LinuxやMac上であれば、あなたのPC上でNuitaを動かすことができます。  
ただし、事前に以下のものをインストールしておく必要があります。

- Ruby 2.6.2
- MySQL 5.7.30
- Yarn
  
1. このレポジトリをクローンし、ディレクトリに移動します。
 
`$ git clone git@github.com:nuita/nuita.git`
`$ cd nuita`

2. Nuitaのコードがあるディレクトリに入り、必要な依存をインストールします。

`$ bundle install`
`$ yarn install --check-files`

3. データベースをセットアップします。

`$ bundle exec rails db:setup`

手元のMySQLにパスワードを設定している場合、`config/database.yml`の`development`に自分のパスワードを追記する必要があるかもしれません。

4. Nuitaを立ち上げます。

`$ bundle exec rails s`

ブラウザに`localhost:3000`にアクセスして、[かわいいチノちゃんの画像](https://www.pixiv.net/artworks/55434358)が表示されていたら成功です!  
（環境変数`PORT`, `HOST`を指定することでホストやポート番号は変更することができます）

## Docker
Docker上でもNuitaを起動させることができます。  
手元の環境を汚したくないあなたにおすすめです。

1. このレポジトリをクローンし、ディレクトリに移動します。

`$ git clone git@github.com:nuita/nuita.git`
`$ cd nuita`

2. コンテナ上で依存関係をインストールします。

`$ docker-compose run --rm app bundle install && yarn install --check-files`
   
3. コンテナ上でデータベースをセットアップします。

`$ docker-compose run --rm app bundle exec rails db:setup`

4. Nuitaを立ち上げます。

`$ docker-compose up`

ブラウザに`localhost:3000`にアクセスして、[かわいいチノちゃんの画像](https://www.pixiv.net/artworks/55434358)が表示されていたら成功です!  

# 開発方針
プルリクエスト・イシュー・コードレビュー等大歓迎です!

新たな機能を追加した場合は、このレポジトリをフォークした上で、自分のレポジトリからこのレポジトリの`master`ブランチに向けてプルリクエストを出してください。  
Github Actionsによって自動的にテストが走ったあと、問題なさそうであればレビューを行った上でマージされます。

## panchira
- NuitaにURIを投稿した際に取得・表示されるデータは[Panchira](https://github.com/nuita/panchira)というgemによるものです。
- 対応するサービスを増やしたい・誤ったデータを修正したい場合は、上掲したレポジトリにリクエストしてください。
