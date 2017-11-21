# プラグインインストール #
このプラグインはQangarooと連携するためのRedmineプラグインです。バージョン3.2.8以上のRedmineに対応します。
Redmineバージョンをアップグレードする必要があるなら、http://guide.redmine.jp/RedmineUpgrade/ を参考してください。

**下記の手順通りにプラグインをインストールしてください。**
1. redmineアプリの`./plugins`フォルダに入る
2. `plugins`のフォルダの中に入ると下記のコマンド
  * `git clone https://github.com/tm-qangaroo/qangaroo_plugin.git`
3. redmineアプリのrootフォルダに戻る
4. gemのインストール。
  * `bundle install --without development test`
5. データベースのマイグレーションとアセッツのコピー
  * `bundle exec rake redmine:plugins:migrate RAILS_ENV=production`
  * `bundle exec rake redmine:plugins NAME=qangaroo_plugin RAILS_ENV=production`
6. redmineアプリのサーバを再起動。

# Plugin Installation Guide #
This is a Redmine plugin designed to integrate Redmine with Qangaroo. It works with Redmine version 3.2.8 or above.
For those who need to upgrade their Redmine, please see http://www.redmine.org/projects/redmine/wiki/RedmineUpgrade.

**Follow the instructions below to install the plugin.**
1. Enter your Redmine application's `./plugins` directory.
2. Inside the `plugins` directory, run the following command:
  * `git clone https://github.com/tm-qangaroo/qangaroo_plugin.git`
3. Return to the root folder of your Redmine application.
4. Install the required plugin gems.
  * `bundle install --without development test`
5. Migrate the database and compile assets.
  * `bundle exec rake redmine:plugins:migrate RAILS_ENV=production`
  * `bundle exec rake redmine:plugins NAME=qangaroo_plugin RAILS_ENV=production`
6. Restart your application's server.
