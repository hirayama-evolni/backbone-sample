window.backbone_sample = window.backbone_sample || {}

# �A�h���X���̓t�H�[���ɑΉ�����View
window.backbone_sample.FormView = Backbone.View.extend
  # �����̃^�O�Ɋ֘A�t����
  el: "#addBook"
  # �R���X�g���N�^(����͓��ɂ�邱�ƂȂ�)
  initialize: (opt) ->
    return

  # �C�x���g��`
  events:
    # �{�^�����N���b�N���ꂽ��addAddress()���Ă�
    'click #add': 'addAddress'

  # �{�^�����N���b�N���ꂽ���ɓ���
  addAddress: (e) ->
    # �f�t�H���g������~
    e.preventDefault()

    formData = {}

    # �l������Ă���
    $('#addBook').children('input').each ( i, el ) ->
      if $(el).val() != ''
        formData[ el.id ] = $( el ).val()
        return

    # �V������model�����
    # �R���N�V�����ɒǉ�����
    # �f�[�^�x�[�X�Ƃ���������
    window.backbone_sample.Collection.create formData

    return
