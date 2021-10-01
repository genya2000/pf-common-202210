NETWORK_ADMIN = $(shell docker network ls | grep imedia_admin_net)
NETWORK_BATCH = $(shell docker network ls | grep imedia_batch_net)
NETWORK_LOG = $(shell docker network ls | grep imedia_log_net)
NETWORK_WEB = $(shell docker network ls | grep imedia_web_net)

help:
	@echo '---------- 環境構築に関するコマンド -----------'
	@echo 'init           -- プロジェクト初期のセットアップを行います※基本的にクローンしてきて1回目のみ実行'
	@echo 'remake         -- 環境を作り直します※dockerの構成等変更になったらこのコマンドを実行してください'
	@echo ''
	@echo '---------- Dockerに関するコマンド ----------'
	@echo 'create-network -- ネットワークを作成します※初回構築時に作成されるのでこのコマンドは基本的に手作業で実行しない'
	@echo 'build          -- イメージをビルドします'
	@echo 'up             -- 新しいコンテナを作成後コンテナを起動します'
	@echo 'start          -- 作成済みのコンテナを再起動します'
	@echo 'restart        -- コンテナを作り直したあと起動します※image、volumeは既存のものを再利用'
	@echo 'stop           -- コンテナを停止します'
	@echo 'down           -- コンテナ、ネットワークを削除します'
	@echo 'destroy        -- コンテナ、ネットワーク、イメージ、ボリュームを削除します'
	@echo 'ps             -- コンテナ一覧を表示します'
	@echo 'logs           -- コンテナのログを表示します'
	@echo 'log-db         -- dbコンテナのログを表示します'
	@echo 'log-db-watch   -- dbコンテナのログを表示し続けます'
	@echo 'log-mailhog    -- mailhogコンテナのログを表示します'
	@echo ''
	@echo '---------- dbコンテナに関するコマンド ----------'
	@echo 'db             -- dbコンテナに接続します'
	@echo 'sql            -- dbコンテナのimediaデータベースに直接接続します'

init:
	@make create-network
	@make build
	@make up

remake:
	@make destroy
	@make create-network
	@make build
	@make up

create-network:
ifeq ($(NETWORK_ADMIN),)
	docker network create imedia_admin_net
endif
ifeq ($(NETWORK_BATCH),)
	docker network create imedia_batch_net
endif
ifeq ($(NETWORK_LOG),)
	docker network create imedia_log_net
endif
ifeq ($(NETWORK_WEB),)
	docker network create imedia_web_net
endif
build:
	docker-compose build --no-cache --force-rm
up:
	docker-compose up -d
start:
	docker-compose start
restart:
	@make down
	@make up
stop:
	docker-compose stop
down:
	docker-compose down
destroy:
	docker-compose down --rmi all --volumes --remove-orphans
ps:
	docker-compose ps
logs:
	docker-compose logs
log-db:
	docker-compose logs db
log-db-watch:
	docker-compose logs --follow db
log-mailhog:
	docker-compose logs mailhog

db:
	docker-compose exec db bash
sql:
	docker-compose exec db bash -c 'mysql -u $$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE'
