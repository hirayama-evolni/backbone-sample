window.backbone_sample = window.backbone_sample || {}

# 一件のアドレスを表すモデルを定義する
window.backbone_sample.Address = Backbone.Model.extend
  defaults:
    # デフォルト設定
    name: "anonymous"
    address: "homeless"
    tel: "no phones"

