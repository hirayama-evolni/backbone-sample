window.backbone_sample = window.backbone_sample || {}

# アドレスのコレクションを定義する
window.backbone_sample.AddressBook = Backbone.Collection.extend
  # 格納するモデル
  model: window.backbone_sample.Address
  # バックエンドのURL
  url: '../app/addresses'
