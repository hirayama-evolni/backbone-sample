window.backbone_sample = window.backbone_sample || {}

$ ->
  # コレクションを作成する
  window.backbone_sample.Collection = new window.backbone_sample.AddressBook()
  # 個々のアドレスを表示する箇所に対応するViewを作成する
  new window.backbone_sample.ListView()
  # アドレス入力フォームに対応するViewを作成する
  new window.backbone_sample.FormView()
  return
