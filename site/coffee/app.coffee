window.backbone_sample = window.backbone_sample || {}

$ ->
  # �R���N�V�������쐬����
  window.backbone_sample.Collection = new window.backbone_sample.AddressBook()
  # �X�̃A�h���X��\������ӏ��ɑΉ�����View���쐬����
  new window.backbone_sample.ListView()
  # �A�h���X���̓t�H�[���ɑΉ�����View���쐬����
  new window.backbone_sample.FormView()
  return
