<?php
App::uses('AppController', 'Controller');

class AddressesController extends AppController {
    public $components = array('RequestHandler');

    protected function returnJSON($data){
        $this->autoRender = false;
        $this->response->type('json');
        $this->response->body(json_encode($data));
    }

    // GET /addresses
    // �S���Ԃ�
    public function index(){
        // �S���擾
        $data = $this->Address->find('all');
      
        // arrah([0] => array('Address' => array(/*data*/))) �Ȃ̂ŁA
        // ��K�w����
        $func = function($v){
            return $v['Address'];
        };
        $data = array_map($func, $data);

        $this->returnJSON($data);
    }
  
    // GET /addresses/id
    // ����͏ȗ�
    public function view($id){
    }
  
    // POST /addresses
    // �ꌏ�ǉ�
    public function add(){
        // save�ɓn���f�[�^�쐬
        $data = array('Address' => 
                      array('name' => $this->request->data['name'],
                            'address' => $this->request->data['address'],
                            'tel' => $this->request->data['tel']));
      
        // DB�ɓ���
        $this->Address->save($data);
      
        $this->returnJSON(array());
    }
  
    // PUT /addresses/id
    // ����͏ȗ�
    public function edit($id){
    }

    // DELETE /addresses/id
    // �ꌏ�폜
    public function delete($id){
        $this->Address->delete($id);
      
        $this->returnJSON(array());
    }
}