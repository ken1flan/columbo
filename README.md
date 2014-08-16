# Columbo

世の中の男性は恥ずかしがり屋さん。
「うちのカミさんが…」と友人や同僚によくボヤくが、それは実はノロケのこと。
そんな不思議な生態を集め、世の中に発信することで、世間の夫婦仲をより良くしようという、[サービス](http://my-wife-said.herokuapp.com/)。

[![Code Climate](https://codeclimate.com/github/ken1flan/columbo/badges/gpa.svg)](https://codeclimate.com/github/ken1flan/columbo)[![Test Coverage](https://codeclimate.com/github/ken1flan/columbo/badges/coverage.svg)](https://codeclimate.com/github/ken1flan/columbo)
[![Dependency Status](https://gemnasium.com/ken1flan/columbo.svg)](https://gemnasium.com/ken1flan/columbo)

## Quick start

### twitterとfacebookにアプリケーションを登録する
twitterアプリケーションを登録し、環境変数に下記項目を設定する。


| 環境変数名                          | 説明                                                  |
| ----------------------------------- | ----------------------------------------------------- |
| COLUMBO_TWITTER_CONSUMER_KEY        | twitterアプリケーションのコンシューマーキー           |
| COLUMBO_TWITTER_CONSUMER_SECRET     | twitterアプリケーションのコンシューマーシークレット   |
| COLUMBO_TWITTER_ACCESS_TOKEN        | twitterアプリケーションのアクセストークン             |
| COLUMBO_TWITTER_ACCESS_TOKEN_SECRET | twitterアプリケーションのアクセストークンシークレット |
| COLUMBO_FACEBOOK_APP_ID             | facebookアプリケーションのID                          |
| COLUMBO_FACEBOOK_APP_SECRET         | facebookアプリケーションのシークレット                |


### アプリケーションの取得と設定、起動
```
git clone git@github.com:ken1flan/columbo.git
cd columbo
bundle install
rake db:migrate
rake twitter:pickup_by_keyword
rails s
```

## 運用

### ツイート関連
#### ツイートを取得する
```
rake twitter:pickup_by_keyword
```

#### 古いツイートを削除する
```
rake twitter:housekeep
```

### サイト管理

#### ユーザの一覧
```
rake user:list
```

#### 管理者
##### 設定
指定したユーザを管理者に設定する。
```
export COLUMBO_ADMINS=2,4  # ユーザのIDをカンマ区切りで。
rake user:set_admins
```

##### 解除
指定したユーザを管理者から元に戻す。
```
export COLUMBO_ADMINS=2,4  # ユーザのIDをカンマ区切りで。
rake user:unset_admins
```
