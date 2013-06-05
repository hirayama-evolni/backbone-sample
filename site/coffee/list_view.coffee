window.backbone_sample = window.backbone_sample || {}

window.backbone_sample.ListView = Backbone.View.extend
  # 既存のタグに関連付ける
  # データを表示するdivのid
  el: "#displayArea"

  # コンストラクタ
  initialize: (opt) ->
    this.collection = window.backbone_sample.Collection

  	## イベントハンドラの設定
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

  # イベント定義
  events: 
    # 削除ボタンクリックでremoveIt()を呼ぶ
    "click button.delete": "removeIt"

  # 個々のデータ表示用テンプレート(コンパイル済み)
  template: Templates.address

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
