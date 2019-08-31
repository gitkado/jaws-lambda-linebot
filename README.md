# AWSを使ってLineBotを作ってみる
![アーキテクチャ](images/line-bot-function.png)

- メッセージを受信するとLambdaが呼び出される
- Lambdaは「Your message is 送信メッセージ」と返却する

## 応用(今回は触れていません)
- 受信メッセージと返却メッセージをDynamoDBに格納
- 画像を受信した場合にS3に画像を保管
- 受信メッセージを元に何かしらの処理を行う

## ことわり
利用サービスおよびRubyの説明は割愛しています。  
必要でしたら別途説明しますので、遠慮なく質問してください。

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
### 1. LINE Developersにアカウント登録 (途中)
- [こちらのサイト](https://developers.line.biz/ja/)でアカウント登録を行なってください。

### 2. LINE MessagingApiを登録 (途中)
- 登録
- LINEのQRコードリーダーでQRコードから友達登録

![]()

### 3. S3バケットを作成
> バケット名を「jaws-osc-kado」としています。

1. 「s3」と入力して、サービスを検索します。

![](images/3-1.png)

2. 「バケットを作成する」をクリックします。

![](images/3-2.png)

3. バケット名とリージョン(東京)を入力して「作成」をクリックします。

![](images/3-3.png)

4. バケットが作成できます。

![](images/3-4.png)

### 4. 開発環境としてCloud9を作成 (途中)
今回のハンズオンは開発環境をクラウドに作成します。  
> EnviromentNameを「jaws-osc-kado」としています。

1. 

![]()

### 5. Cloud9構築(Ruby2.5, SAM)
元々インストールされているRubyとSAMのバージョンを変更します。  
[こちらのサイト](https://gitkado.hatenadiary.jp/entry/20190701/1561983034)を参考に行なってください。  

### 6. [GitHub](https://github.com/gitkado/jaws-lambda-linebot)からソースを取得
以下のコマンドでソースを取得します。
- 今回必要なファイルになります。
  - function.rb (LineBotが呼び出す処理)
  - Gemfile (開発で必要なライブラリ定義)
  - template.yaml (AWSに自動構築する設計図)

```sh
$ git clone https://github.com/gitkado/jaws-lambda-linebot.git
```

### 7. Gemソース取得
Lambdaで標準以外のGem(ライブラリ)を使用する場合は、GemのソースをLambdaに含める必要があります。  
以下の手順でGemのソースを取得します。

```sh
$ cd jaws-lambda-linebot
$ bundle install
$ bundle install --deployment
```

### 8. template.yamlのENVにLINE MessagingApi情報を追記 (途中)
1. ``「LINE MessagingApiを登録」``で登録したMessagingApiを確認します。

![]()

2. template.yamlの **【LINE Developersから取得】** を修正して保存します。

```yaml
# template.yaml(17行目~)
LINE_CHANNEL_ID: 【LINE Developersから取得】
LINE_CHANNEL_SECRET: 【LINE Developersから取得】
LINE_CHANNEL_TOKEN: 【LINE Developersから取得】
```

### 9. SAMコマンド実行
**【バケット名】** は、``「S3バケットを作成」``で作成したバケット名に置き換える必要があります。  
以下のコマンドをそれぞれ実行してLambdaとApiGatewayを作成します。  

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
- 以下のリソースが作成されていることを確認してください。
  - CloudFormation
  - Lambda
  - ApiGateway

### 11. LINEで試す
``「LINE MessagingApiを登録」``でQRコードから登録したLINEアカウントにメッセージを送信して試してみてください。

---

### 参考
[GitHub: LineBotSdk](https://github.com/line/line-bot-sdk-ruby)  
[LINE MessagingApi 利用登録手順](https://jp.fujitsu.com/solutions/cloud/k5/playground/webhandson/preparation/06.html)  
[LINE MessagingApi 自動返信解除手順](https://www.virtual-surfer.com/entry/2018/07/22/190000)  
