# AWSを使ってLineBotを作ってみる
![アーキテクチャ](images/line-bot-function.png)

- メッセージを受信するとLambdaが呼び出される
- Lambdaは「Your message is 送信メッセージ」と返却する

## 応用(今回は触れていません)
- 受信メッセージと返却メッセージをDynamoDBに格納
- 画像を受信した場合にS3に画像を保管
- 受信メッセージを元に何かしらの処理を行う

# 目的
- 身近なアプリをHackして楽しんでほしい
- サーバレスを体験してほしい
- Cloud9便利ってのを感じてほしい

## 必要なもの
- AWSアカウント
  - 無料枠で完結
- LINEアカウント
  - 無料

## 利用サービス
### AWS
- S3
- Cloud9
- CloudFormation(SAM)
- Lambda
- ApiGateway

### LINE(Developers)
- MessagingApi

## 手順
### 1. LINE Developersにアカウント登録
- [こちらのサイト](https://developers.line.biz/ja/)でアカウント登録を行なってください
### 2. LINE MessagingApiを登録
- 登録
- LINEのQRコードリーダーでQRコードから友達登録
### 3. S3バケットを作成
### 4. 開発環境としてCloud9を作成
### 5. Cloud9構築(Ruby2.5, SAM)
- [こちらのサイト](https://gitkado.hatenadiary.jp/entry/20190701/1561983034)を参考に行なってください
### 6. GitHubからソースを取得
- function.rb (LineBotが呼び出す処理)
- Gemfile (開発で必要なライブラリ定義)
- template.yaml (AWSに自動構築する設計図)

```sh
$ git clone https://github.com/gitkado/jaws-lambda-linebot.git
```

### 7. Gemソース取得

```sh
$ cd jaws-lambda-linebot
$ bundle install
$ bundle install --deployment
```

### 8. template.yamlのENVにLINE MessagingApi情報を追記
### 9. SAMコマンド実行
- 【バケット名】は、``「S3バケットを作成」``で作成したバケット名に置き換えてください

```sh
$ sam package \
    --template-file template.yaml \
    --s3-bucket 【バケット名】] \
    --output-template-file packaged-template.yaml \
    --region ap-northeast-1
$ sam deploy \
    --template-file packaged-template.yaml \
    --stack-name cfn-lambda-linebot \
    --capabilities CAPABILITY_IAM
```

### 10. 確認
- 以下のリソースが作成されていることを確認してください
  - CloudFormation
  - Lambda
  - ApiGateway

### 11. LINEで試す

---

### 参考
[GitHub: LineBotSdk](https://github.com/line/line-bot-sdk-ruby)  
[LINE MessagingApi 利用登録手順](https://jp.fujitsu.com/solutions/cloud/k5/playground/webhandson/preparation/06.html)  
[LINE MessagingApi 自動返信解除手順](https://www.virtual-surfer.com/entry/2018/07/22/190000)  
