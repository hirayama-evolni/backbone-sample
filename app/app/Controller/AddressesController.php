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
    // ‘SŒ•Ô‚·
    public function index(){
        // ‘SŒæ“¾
        $data = $this->Address->find('all');
      
        // arrah([0] => array('Address' => array(/*data*/))) ‚È‚Ì‚ÅA
        // ˆêŠK‘w”²‚­
        $func = function($v){
            return $v['Address'];
        };
        $data = array_map($func, $data);

        $this->returnJSON($data);
    }
  
    // GET /addresses/id
    // ¡‰ñ‚ÍÈ—ª
    public function view($id){
    }
  
    // POST /addresses
    // ˆêŒ’Ç‰Á
    public function add(){
        // save‚É“n‚·ƒf[ƒ^ì¬
        $data = array('Address' => 
                      array('name' => $this->request->data['name'],
                            'address' => $this->request->data['address'],
                            'tel' => $this->request->data['tel']));
      
        // DB‚É“Š“ü
        $this->Address->save($data);
      
        $this->returnJSON(array());
    }
  
    // PUT /addresses/id
    // ¡‰ñ‚ÍÈ—ª
    public function edit($id){
    }

    // DELETE /addresses/id
    // ˆêŒíœ
    public function delete($id){
        $this->Address->delete($id);
      
        $this->returnJSON(array());
    }
}