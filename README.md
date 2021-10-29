# cw-imedia-common
iMediaの開発で共通して使用するコンテナを管理するリポジトリです。
- データベースコンテナ
- メールコンテナ
- S3互換オブジェクト(MinIO)コンテナ

<br>

## 1. Dockerネットワーク&コンテナ対応表
iMediaの開発で使用するコンテナ群とネットワークの対応表です。

||admin|api|app|batch|db|log|mailhog|pagebuilder|minio|
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:--:|
|imedia_admin_net|○||||○||○|||
|imedia_batch_net||||○|○||○|||
|imedia_log_net|||||○|○||||
|imedia_web_net||○|○||○||○|○|○|

<br>

## 2. Requirements
- docker, docker-composeがインストールされていること
- makeコマンドが使用できること（任意ですがあると初期設定が楽です）

<br>

## 3. Installation
※M1チップのMacを使用している方は、以下の手順に進む前に`docker-compose.yml`を確認し指定箇所を**コメントイン**してください
### 3.1. makeコマンド使える方はこちら
1. ホストPC上でdockerが起動していることを確認
2. 自身の設定(sshまたはhttps)に応じて下記コマンドを実行
  - ssh
    ```sh
    git clone git@github.com:gizumo-inc/cw-imedia-common.git && cd cw-imedia-common && make init
    ```
  - https
    ```sh
    git clone https://github.com/gizumo-inc/cw-imedia-common.git && cd cw-imedia-common && make init
    ```
3. コンソールで`make ps`を実行して、dbとmailhogのSTATUSがそれぞれ`running`になっていることを確認
4. ブラウザで[localhost:8025](http://localhost:8025)にアクセスして、mailhogの画面が表示されること確認
5. ブラウザで[localhost:9001](http://localhost:9001)にアクセスして、MinIOの画面が表示されること確認

<br>

### 3.2. makeコマンド使えない方はこちら
1. ホストPC上でdockerが起動していることを確認
2. 自身の設定(sshまたはhttps)に応じて下記コマンドを実行
     - ssh
       ```sh
       git clone git@github.com:gizumo-inc/cw-imedia-common.git && cd cw-imedia-common
       ```
     - https
       ```sh
       git clone https://github.com/gizumo-inc/cw-imedia-common.git && cd cw-imedia-common
       ```
3. ネットワークを作成  
   ※事前にimediaの他のプロジェクトで環境構築を行った場合は、一部ネットワークが既に存在するエラーが表示されます。その場合は該当ネットワークの作成はスキップ。
    ```sh
    docker network create imedia_admin_net
    docker network create imedia_batch_net
    docker network create imedia_log_net
    docker network create imedia_web_net
    ```
4. コンテナをビルドして起動
   ```sh
   docker-compose up -d --build
   ```
5. コンソールで`docker-compose ps`を実行して、dbとmailhogのStateがそれぞれ`up`になっていることを確認
6. ブラウザで[localhost:8025](http://localhost:8025)にアクセスして、mailhogの画面が表示されること確認
7. ブラウザで[localhost:9001](http://localhost:9001)にアクセスして、MinIOの画面が表示されること確認

## 4. その他
- このプロジェクトは`make`コマンドで一通りの操作をすることができます  
  ※コンソールで`make help`を実行すると使用できるコマンドと説明が表示されます
