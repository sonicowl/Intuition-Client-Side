<?php

class GlobalController extends Zend_Rest_Controller
{
	   	public $result_code = '';
		public $result_action= '';
	   	
		public function preDispatch()
		{
	    	$request = new Zend_Controller_Request_Http();
	    	$key = $request->getHeader('x-apikey');
		}
	
    	public function init()
    	{
        	$bootstrap = $this->getInvokeArg('bootstrap');
			$options = $bootstrap->getOption('resources');
			$contextSwitch = $this->_helper->getHelper('contextSwitch');
 			$contextSwitch->addActionContext('get', array('xml','json'))->initContext();
$this->_helper->viewRenderer->setNeverRender();	
	 	}
	
		/**
	     * 
		 * LIST USERS
		 * 
	     */
	
	    public function indexAction()
	    {

			$this->_forward('index');
			
		}

	 	/**
	     * The list action is the default for the rest controller
	     * Forward to index
	     */ 
	
	    public function listAction()
	    {
			$this->_forward('index');
 
		}

	    /**
	     * The get action handles GET requests and receives an 'id' parameter; it 
	     * should respond with the server resource state of the resource identified
	     * by the 'id' value.
	     * Get Global Score
	     */ 
	
	    public function getAction()
	    {
			$params = $this->_getAllParams();
			
			$time = $this->getRequest()->getParam('time');
						
			$loadmore = "";
			
			$recordsModel = new Model_Record(); 
		  	$record = $recordsModel->fetchRecordsByTime($time);
			if ($record == null){
				$this->result_code = '0';
				$this->result_action = 'Not Found';
			}
			else{
				$this->result_code = '1';
				$this->result_action = 'View Record';
			}
			$this->view->entry = $record;
		}

	    /**
	     * The post action handles POST requests; it should accept and digest a
	     * POSTed resource representation and persist the resource state.
	     * 
		 * ADD OR UPDATE A USER
	     */
	
	    public function postAction() {
			$this->_forward('index');
	    }

	    /**
	     * The put action handles PUT requests and receives an 'id' parameter; it 
	     * should update the server resource state of the resource identified by 
	     * the 'id' value.
	     */  
	    public function putAction() {
			$this->_forward('index');
	    }

	    /**
	     * The delete action handles DELETE requests and receives an 'id' 
	     * parameter; it should update the server resource state of the resource
	     * identified by the 'id' value.
	     */  
	
	    public function deleteAction() {
			$this->_forward('index');
		}


}
