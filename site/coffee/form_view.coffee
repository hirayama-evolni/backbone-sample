window.backbone_sample = window.backbone_sample || {}

# アドレス入力フォームに対応するView
window.backbone_sample.FormView = Backbone.View.extend
  # 既存のタグに関連付ける
  el: "#addBook"
  # コンストラクタ(今回は特にやることなし)
  initialize: (opt) ->
    return

  # イベント定義
  events:
    # ボタンがクリックされたらaddAddress()を呼ぶ
    'click #add': 'addAddress'

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
