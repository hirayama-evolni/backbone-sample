# 概要

今回はクライアントMVCの概要を紹介するのが目的です。

# クライアントMVC？

残念ながら何か魔法の杖のようなものではないです。

これまで主にサーバサイドで行なってきたMVCパターンを、クライアントサイ
ド重視に持っていくための仕組みです。


## Controller

クライアントサイドなので通常Controllerそのものにあたるパーツはありませ
ん。

## Model

これまでどおりデータそのものを表します。サーバーサイドのバックエンドと
つながっています。

## View

Modelを使用して表示を行ったり、Modelの変更を監視して表示を更新したりし
ます。

## サーバーサイド

基本的にバックエンドとしてデータベースとのインターフェースに徹します。

## 何がうれしいの？

サーバーサイドのMVCに対してうれしいところと言えば…よりコンポーネント
が細分化できて分業がしやすくなるのではないでしょうか。

RailsやCakePHPなどフルスタックのフレームワークでは、

* ひとつのControllerの中に各アクションに対応する大量のコードが書かれる
  … 個別に作業しにくい
* Viewの中にロジックをたくさん書きがち … マークアップの人ときれいに分
  業できない
* 近くにあるのでControllerとViewが癒着しがち
* rubyなりPHPなりができる人を探してかき集める必要がある

のような弊害があります。

クライアントMVCにすると、

* サーバーサイドはほぼデータベースとのやり取りのみで、クライアントサイ
  ドのバックエンドとしてのみ機能する … サーバーサイドがシンプルに
* HTMLは変化が必要な部分を除いて静的なものが使える … マークアップから
  上がってきたものがわりとそのまま使える
* 変化が必要な部分は個別の処理とHTMLテンプレートに小さい単位で切り出して分業できる
* 今時一番習得者が多い(?)JavaScriptがメインなので人が集めやすい

など、より独立した作業単位で製作がしやすくなります。

# Backbone.js

[Backbone.js](http://backbonejs.org/)はいわゆるクライアントサイドMVCを
実現するためのJavaScriptライブラリです。

Backbone.jsは文字通り骨格のみに徹しており、骨格以外の自由度が高く、基
本的なサンプルが作りやすいので今回採用しました。

## Backbone.jsの主な構成要素

### Model

個々のデータを表します。

### Collection

Modelの集合体を表します。

例えば一覧表示の際にデータをまとめて取得するなどの処理はCollectionを使
うとやりやすいです。

### View

HTML全体をどうこうするものではなく、HTML内のModelと関連する部分(入力
フォームや一覧表示部分など)それぞれに対応して存在します。「このイベント
が来たらこの処理をする」ようなことを記述するので、どちらかというとここ
がControllerに近いです。

### Event

Model、CollectionとViewを結びつけるのがEventです。

例えばCollection内のModelが変更された場合`change`イベントが発生するの
で、Viewでそれを監視して、発生したら表示を更新する、のようになります。


# サンプルアプリケーション

## 概要

データの一覧、新規作成、削除ができる簡単な住所録管理アプリを作ってみま
す。

## ミドルウェアなど

バックエンドは[MySQL](http://www.mysql.com/)と[CakePHP](http://cakephp.org/)で作成します。

フロント側は、せっかくなのでプリプロセッサ系を多用しています。

* JS … [CoffeeScript](http://coffeescript.org/)
* CSS … [SASS](http://sass-lang.com/)
* テンプレートエンジン … [Hogan](http://twitter.github.io/hogan.js/)

開発タスク実行などは、Node.js系のツールを使用しています。

* [Node.js](http://nodejs.org/)
* [Grunt](http://gruntjs.com/)
* [bower](http://bower.io/)

## ディレクトリ構成

```
|-- README.md
|-- app … CakePHPのバックエンド
|   `-- app
|       `-- Controller
|           `-- AddressesController.php
`-- site … フロントエンド
    |-- Gruntfile.js
    |-- bower.json
    |-- coffee
    |   |-- address.coffee
    |   |-- address_book.coffee
    |   |-- app.coffee
    |   |-- form_view.coffee
    |   `-- list_view.coffee
    |-- css
    |-- index.html
    |-- js
    |-- package.json
    |-- sass
    |   `-- main.scss
    `-- templates
        `-- address.tmpl
```

## セットアップ

cloneしてウェブサーバの配下に置いてください。

### データベース

[app/create_table.sql](https://github.com/hirayama-evolni/backbone-sample/blob/master/app/create_table.sql)
を使用してテーブルを作成します。

テーブルは、名前と住所と電話番号を格納するだけのシンプルなものです。

```SQL
create table addresses (
  id integer auto_increment primary key,
  name text,
  address text,
  tel text
);
```

### バックエンド

app以下にCakePHPのファイルがあります。app/Config/database.phpを環境に
合わせて作成してください。

### フロントエンド

1. siteディレクトリに移動
2. npm install -g grunt-cli bower
3. npm install
4. bower install
5. grunt

## コードの詳細

### バックエンド

addressesテーブルに対応するAddressesControllerを用意しています。

まず、
[このように](https://github.com/hirayama-evolni/backbone-sample/commit/effb640422babdbf3103a72f4f4c6f28d52fda4c#app/app/Config/routes.php)`Router::mapResources()`
を使ってAddressesControllerにRESTマッピングを付けています([詳細はこちら](http://book.cakephp.org/2.0/ja/development/rest.html))。

対応するメソッドの処理は単純ですので
[ソース](https://github.com/hirayama-evolni/backbone-sample/blob/master/app/app/Controller/AddressesController.php)
を参照してください。

* 全件取得
* 一件追加
* 一件削除

のインターフェースを作成しています。それ以外は今回は省略しました。

### HTML

#### index.html

head内で依存するcssとjsを読み込んでいます。

template.jsは、hoganのテンプレートをjsにコンパイルしたものです。
all.jsは*.coffeeファイルをコンパイルしてひとつにまとめたものです。

bodyの最初に新規作成用のフォームがあり、そのあとの`div#displayArea`が
データの一覧を表示させる領域になります。

### モデル

ここからBackbone.jsの世界に入ります。

まずaddressesテーブルに対応するモデルを定義します。

Backbone.jsのモデルを定義する際には、`Backbone.Model.extend`メソッドを
使用します。引数にはインスタンスプロパティの入ったObjectを渡します。

[address.coffee](https://github.com/hirayama-evolni/backbone-sample/blob/master/site/coffee/address.coffee)
より：

```coffeescript
# 一件のアドレスを表すモデルを定義する
window.backbone_sample.Address = Backbone.Model.extend
  defaults:
    # デフォルト設定
    name: "anonymous"
    address: "homeless"
    tel: "no phones"
```

ここは、各値のデフォルト値を指定してAddressモデルを作成しています。

### コレクション

次にAddressモデルの集合であるコレクションを定義します。

コレクションを定義するには、モデルと同じように
`Backbone.Collection.extend`を使用します。

[address_book.coffee](https://github.com/hirayama-evolni/backbone-sample/blob/master/site/coffee/address_book.coffee)より：

```coffeescript
# アドレスのコレクションを定義する
window.backbone_sample.AddressBook = Backbone.Collection.extend
  # 格納するモデル
  model: window.backbone_sample.Address
  # バックエンドのURL
  url: '../app/addresses'
```

modelプロパティで格納するモデルの型を設定します。

urlプロパティは、バックエンドのURLを設定しています。バックエンドからの
データの取得やフロントエンドでの変更のバックエンドへの反映はこのURLを
使用して行われます。

### フォームのビュー

次にビューを定義します。

ビューを定義するには、これまでと同じように
`Backbone.View.extend`を使用します。

[form_view.coffee](https://github.com/hirayama-evolni/backbone-sample/blob/master/site/coffee/form_view.coffee)より：

```coffeescript
# アドレス入力フォームに対応するView
window.backbone_sample.FormView = Backbone.View.extend
～～～～
```

ビューはelプロパティで既存のタグに関連付けるか、tagName、
className、idプロパティで指定した新しいタグを内包するかのどちらかにな
ります。

今回はindex.html内のformタグに関連付けます。

```coffeescript
  # 既存のタグに関連付ける
  el: "#addBook"
```

eventsプロパティに処理するイベントを記述します。
形式は、`"event selector": "callback"`となります。

今回はボタンがクリックされたらaddAddress()メソッドが呼ばれるようにしま
す。

```coffeescript
  # イベント定義
  events:
    # ボタンがクリックされたらaddAddress()を呼ぶ
    'click #add': 'addAddress'
```

最後にaddAddressメソッドを定義します。

処理は入力部から値を取ってきてobjectを作成して、それを元にモデルを追加
しています。

```coffeescript
  # ボタンがクリックされた時に動く
  addAddress: (e) ->
    # デフォルト動作を停止
    e.preventDefault()

    formData = {}

    # 値を取ってくる
    $('#addBook').children('input').each ( i, el ) ->
      if $(el).val() != ''
        formData[ el.id ] = $( el ).val()
        return

    # 新しいいmodelを作る
    # コレクションに追加する
    # データベースとも同期する
    window.backbone_sample.Collection.create formData

    return
```

最後のCollection.createメソッドで、

1. コレクションが内包するモデルを新規作成
2. 引数で指定された値を設定
3. バックエンドに登録
4. コレクションに追加

という処理を一気に行っています。モデルを追加するとコレクションのaddイ
ベントが発生し、次に出てくるリストビューでそれを拾って表示の更新をしま
す。

### リスト表示のビュー

前節と同様の方法でビューを定義します。

```coffeescript
window.backbone_sample.ListView = Backbone.View.extend
```

今回も既存のタグに関連付けます。

```coffeescript
  # 既存のタグに関連付ける
  # データを表示するdivのid
  el: "#displayArea"
```

コンストラクタではコレクションを経由したデータの取得と、コレクションの
イベントに対応するハンドラを定義しています。

```coffeescript
  # コンストラクタ
  initialize: (opt) ->
    this.collection = window.backbone_sample.Collection

    # resetされると(この場合データを読み込み終わると)データ表示
    this.listenTo this.collection, "reset", this.render
    # 追加されるとデータ(再)表示
    this.listenTo this.collection, "add", this.render
    # 削除されるとデータ(再)表示
    this.listenTo this.collection, "destroy", this.render

    # サーバサイドからデータを取ってくる
    this.collection.fetch
      reset: true

    return
```

まずイベントハンドラの定義をしています。

ここでは、`collection.fetch`メソッドが終了した際に発生する`reset`イベ
ント、データが追加された際に発生する`add`イベント、データが削除された
際に発生する`destroy`イベントの各イベントに対して、データ(コレクション
の内容)を(再)表示する`render`メソッドが呼ばれるように設定しています。

`listenTo`メソッドは自分以外のオブジェクトのイベントに対してイベントハ
ンドラを設定する際に使用します。

`collection.fetch`メソッドでは、バックエンドからデータを取得し、それぞ
れのデータに対応するモデルを作成してコレクションに追加します。

通常`collection.fetch`メソッドは既存のモデルを上書きする形でデータを登
録しますが、ここでは`reset`オプションを付けて、バックエンドから返ってき
たデータのリストに完全に置き換えるように指定しています。`reset`オプショ
ンを付けた場合、終了時に`reset`イベントが発生します。

次に、自分配下のイベントハンドラを定義します。

```coffeescript
  # イベント定義
  events: 
    # 削除ボタンクリックでremoveIt()を呼ぶ
    "click button.delete": "removeIt"
```

`button.delete`は
[テンプレート](https://github.com/hirayama-evolni/backbone-sample/blob/master/site/templates/address.tmpl)
内にある削除ボタンに対応します。そのボタンをクリックすると、
`removeIt`メソッドを呼び出すように設定しています。

`removeIt`メソッドは下記のようになっています。削除ボタンのidにモデルの
idが仕込んであり、そのidに対応するモデルを取得して削除しています。
モデルを特定する方法はもう少しきれいにできるはずですがあまり考えてない
だけですすみません。

```coffeescript
  # 削除ボタンが押されると呼ばれる
  removeIt: (e) ->
    # modelのidがボタンのidに仕込んである
    # ボタンのidの値を取得
    tmp_id = $(e.currentTarget).attr "id"
    # modelのidを抽出
    model_id = (tmp_id.match(/^btn_(.*)$/))[1];
    # modelを取得してdestroyを呼ぶ
    # destroyイベントはcollectionにも飛んでくる
    this.collection.get(model_id).destroy();
```

最後の`destroy`メソッドでバックエンドからもデータが削除されます。削除
されると`destroy`イベントが発生しますがこれは親のコレクションにも伝播
し、コレクションの`destroy`イベントが来たらデータを再表示するよう
に設定してあります。

最後に表示関係です。

Hoganの
[テンプレート](https://github.com/hirayama-evolni/backbone-sample/blob/master/site/templates/address.tmpl)
ではデータ１件分に対応するHTMLが定義してあります。

```html
<div class="address">
  <ul>
    <li>名前：{{name}}</li>
    <li>住所：{{address}}</li>
    <li>電話：{{tel}}</li>
  </ul>
  <button id="btn_{{id}}" class="btn delete">削除</button>
</div>
```
`{{}}`で囲ってある部分がデータの値に置き換えられます。

テンプレートは事前にJavaScriptのコードにコンパイルされ、
`js/template.js`に出力されます。

```coffeescript
  # 個々のデータ表示用テンプレート(コンパイル済み)
  template: Templates.address
```

Templatesオブジェクトはコンパイルされたテンプレートが格納されるもので、
addressプロパティには先程のテンプレートをコンパイルしたメソッドが設定
されています。

最後にモデル(コレクション)に変化があった場合に(再)表示を行う`render`メ
ソッドです。

```coffeescript
  # 表示
  render: ->
    # 非効率ですが呼び出しを単純化するために毎回全消し→全追加してます
    # 一旦全消去
    this.$el.html "";
    # コレクションの要素ごとにテンプレートをレンダリングして結果を追加する
    this.collection.each (item) ->
      this.$el.append this.template.render item.toJSON()
      return
    ,this
    # イベント再設定
    this.delegateEvents
```

`$el`というのは、このビューと関連付けられているタグに対応するjQueryオ
ブジェクトです。`$el`に対してはjQueryのメソッドが使用できます。

1. div#displayAreaの中身をクリアする
2. コレクションのアイテムごとに、アイテムの値を当てはめてテンプレート
   をレンダリングして、div#displayAreaの中身に追加する
3. 削除ボタンに対するclickイベントを再設定する

という処理をしています。

### 初期化

ページロード時の初期化処理は
[app.coffee](https://github.com/hirayama-evolni/backbone-sample/blob/master/site/coffee/app.coffee)
で行なっています。

```coffeescript
$ ->
  # コレクションを作成する
  window.backbone_sample.Collection = new window.backbone_sample.AddressBook()
  # 個々のアドレスを表示する箇所に対応するViewを作成する
  new window.backbone_sample.ListView()
  # アドレス入力フォームに対応するViewを作成する
  new window.backbone_sample.FormView()
  return
```

jQueryの$()に対して、

1. 共用のコレクションを作成する
2. リスト表示のビューを作成する
3. フォームのビューを作成する

処理を追加して初期化時に実行されるようにしています。

## 処理の流れ

一連の処理の流れがわかりにくいかと思いますので解説します。

### 初期化時

1. ListViewのコンストラクタ内で`Collections.fetch`メソッドを呼び出し、

   1. バックエンドからデータを取得し
   2. それぞれのデータに対応するモデルを生成し
   3. コレクションに追加する
   4. `reset`イベントが発生

2. `reset`イベントを受けて、`render`メソッドが呼ばれ、各モデルをテンプ
   レートに当てはめて、出力結果をHTMLに追加する

  1. div#displayAreaの中身をクリアする
  2. コレクションのアイテムごとに、アイテムの値を当てはめてテンプレート
     をレンダリングして、div#displayAreaの中身に追加する
  3. 削除ボタンに対するclickイベントを再設定する

### データ追加時

1. 入力部にデータを入力して追加ボタンをクリック
2. `click`イベントを受けてフォームビューの`addAddress`メソッドが呼ばれ
   る
3. `addAddress`メソッドで、

  1. 入力部から値を取得して、各値の入ったオブジェクトを作成
  2. コレクションの`create`メソッドにそのオブジェクトを渡して、

  	1. コレクションが内包するモデルを新規作成
    2. 引数で指定されたオブジェクトの値を設定
    3. バックエンドに登録
    4. コレクションに追加

4. コレクションのモデルが追加されるので、`add`イベントが発生
5. `add`イベントを受けて、リスト表示ビューのrenderメソッドが呼ばれて再
   表示が行われる

  1. div#displayAreaの中身をクリアする
  2. コレクションのアイテムごとに、アイテムの値を当てはめてテンプレート
     をレンダリングして、div#displayAreaの中身に追加する
  3. 削除ボタンに対するclickイベントを再設定する

### データ削除時

1. 削除ボタンが押される
2. `click`イベントを受けてリスト表示ビューの`removeIt`メソッドが呼ばれ
   る

   1. 削除対象のモデルを削除する
   2. コレクションの`destroy`イベントが発生する

3. `destroy`イベントを受けて、リスト表示ビューのrenderメソッドが呼ばれ
   て再表示が行われる

  1. div#displayAreaの中身をクリアする
  2. コレクションのアイテムごとに、アイテムの値を当てはめてテンプレート
     をレンダリングして、div#displayAreaの中身に追加する
  3. 削除ボタンに対するclickイベントを再設定する

# まとめ

ちょっとわかりにくかったかもしれませんが、以上です。

サーバー側にがっつり書くよりも、小さくモジュール化できそうだしでいい
感じな気がします。

また、localStorageと組み合わせればサーバがなくても開発できるので、場所
も選びません。

PHPなどサーバーサイドの言語に詳しくなくても、JavaScriptが書ければ開発
に参加できるのも今時は敷居が低くなって良いです。

Backboneはシンプルで自由度が高いので、他のライブラリと組み合わせること
もやりやすく、そういう意味では採用しやすいでしょう。

チャンスがあれば積極的に導入してみたいと思っています。
