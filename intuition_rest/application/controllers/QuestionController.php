<?php

class QuestionController extends Zend_Rest_Controller
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

			$questionsModel = new Model_Question(); 
		  	$record = $questionsModel->fetchQuestions();
			if ($record == null){
				$this->result_code = '0';
				$this->result_action = 'Not Found';
			}
			else{
				$this->result_code = '1';
				$this->result_action = 'View Record';
			}
			$this->view->records = $record;
		}

	    /**
	     * The post action handles POST requests; it should accept and digest a
	     * POSTed resource representation and persist the resource state.
	     * 
		 * ADD OR UPDATE A USER
	     */
	
	    public function postAction() {
			$recordsModel = new Model_Question(); 
			$params = $this->_getAllParams();
			unset($params['controller']);
	        unset($params['action']);
	        unset($params['module']);
			$mtvid = $this->getRequest()->getParam('mtvid');
			$facebookid = $this->getRequest()->getParam('facebookid');
			$name = $this->getRequest()->getParam('name');
			$gameLevel = $this->getRequest()->getParam('gameLevel');
			$scoreValue = $this->getRequest()->getParam('scoreValue');
			$gameCenterId = $this->getRequest()->getParam('gameCenterId');
			$longitude = $this->getRequest()->getParam('longitude');
			$latitude = $this->getRequest()->getParam('latitude');
			$date = $this->getRequest()->getParam('date'); 
			$record = $recordsModel->addRecord(null, $mtvid, $facebookid, $name, $gameLevel, $scoreValue, $gameCenterId, $longitude, $latitude, $date);
			print "{\"user_id\":\"".$record."\",\"name\":\"".$record."\",\"best_score\":\"".$record."\"}";
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
