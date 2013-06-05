window.backbone_sample = window.backbone_sample || {}

window.backbone_sample.ListView = Backbone.View.extend
  # �����̃^�O�Ɋ֘A�t����
  # �f�[�^��\������div��id
  el: "#displayArea"

  # �R���X�g���N�^
  initialize: (opt) ->
    this.collection = window.backbone_sample.Collection

  	## �C�x���g�n���h���̐ݒ�
    # reset������(���̏ꍇ�f�[�^��ǂݍ��ݏI����)�f�[�^�\��
    this.listenTo this.collection, "reset", this.render
    # �ǉ������ƃf�[�^(��)�\��
    this.listenTo this.collection, "add", this.render
    # �폜�����ƃf�[�^(��)�\��
    this.listenTo this.collection, "destroy", this.render

    # �T�[�o�T�C�h����f�[�^������Ă���
    this.collection.fetch
      reset: true

    return

  # �C�x���g��`
  events: 
    # �폜�{�^���N���b�N��removeIt()���Ă�
    "click button.delete": "removeIt"

  # �X�̃f�[�^�\���p�e���v���[�g(�R���p�C���ς�)
  template: Templates.address

  # �폜�{�^�����������ƌĂ΂��
  removeIt: (e) ->
    # model��id���{�^����id�Ɏd����ł���
    # �{�^����id�̒l���擾
    tmp_id = $(e.currentTarget).attr "id"
    # model��id�𒊏o
    model_id = (tmp_id.match(/^btn_(.*)$/))[1];
    # model���擾����destroy���Ă�
    # destroy�C�x���g��collection�ɂ����ł���
    this.collection.get(model_id).destroy();

  # �\��
  render: ->
    # ������ł����Ăяo����P�������邽�߂ɖ���S�������S�ǉ����Ă܂�
    # ��U�S����
    this.$el.html "";
    # �R���N�V�����̗v�f���ƂɃe���v���[�g�������_�����O���Č��ʂ�ǉ�����
    this.collection.each (item) ->
      this.$el.append this.template.render item.toJSON()
      return
    ,this
    # �C�x���g�Đݒ�
    this.delegateEvents
