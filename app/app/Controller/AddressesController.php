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
    // 全件返す
    public function index(){
        // 全件取得
        $data = $this->Address->find('all');
      
        // arrah([0] => array('Address' => array(/*data*/))) なので、
        // 一階層抜く
        $func = function($v){
            return $v['Address'];
        };
        $data = array_map($func, $data);

        $this->returnJSON($data);
    }
  
    // GET /addresses/id
    // 今回は省略
    public function view($id){
    }
  
    // POST /addresses
    // 一件追加
    public function add(){
        // saveに渡すデータ作成
        $data = array('Address' => 
                      array('name' => $this->request->data['name'],
                            'address' => $this->request->data['address'],
                            'tel' => $this->request->data['tel']));
      
        // DBに投入
        $this->Address->save($data);
      
        $this->returnJSON(array());
    }
  
    // PUT /addresses/id
    // 今回は省略
    public function edit($id){
    }

    // DELETE /addresses/id
    // 一件削除
    public function delete($id){
        $this->Address->delete($id);
      
        $this->returnJSON(array());
    }
}