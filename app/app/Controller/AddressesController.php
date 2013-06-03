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
    // SÔ·
    public function index(){
        // Sæ¾
        $data = $this->Address->find('all');
      
        // arrah([0] => array('Address' => array(/*data*/))) ÈÌÅA
        // êKw²­
        $func = function($v){
            return $v['Address'];
        };
        $data = array_map($func, $data);

        $this->returnJSON($data);
    }
  
    // GET /addresses/id
    // ¡ñÍÈª
    public function view($id){
    }
  
    // POST /addresses
    // êÇÁ
    public function add(){
        // saveÉn·f[^ì¬
        $data = array('Address' => 
                      array('name' => $this->request->data['name'],
                            'address' => $this->request->data['address'],
                            'tel' => $this->request->data['tel']));
      
        // DBÉü
        $this->Address->save($data);
      
        $this->returnJSON(array());
    }
  
    // PUT /addresses/id
    // ¡ñÍÈª
    public function edit($id){
    }

    // DELETE /addresses/id
    // êí
    public function delete($id){
        $this->Address->delete($id);
      
        $this->returnJSON(array());
    }
}