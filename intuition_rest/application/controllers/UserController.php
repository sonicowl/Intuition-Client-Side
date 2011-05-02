<?php

class UserController extends Zend_Rest_Controller
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
		//	$this->_helper->viewRenderer->setNeverRender();	
	 	}
	
		/**
	     * 
		 * LIST USERS
		 * 
	     */
	
	    public function indexAction()
	    {
			//$this->getResponse ()->setHeader ( 'Content-Type', 'text/xml' );
		/*	$usersModel = new Model_User(); 
	  		$user = $usersModel->fetchUsers();
			if ($user == null){
				$this->result_code = '0';
				$this->result_action = 'Not Found';
			}
			else{
				$this->result_code = '1';
				$this->result_action = 'List Users';
			 	print $this->_handleStruct($user);	
			}
			$this->_forward('index'); */
			$this->view->team = 'a';
			        $this->view->players = array(
			            'David James',
			            'Ashley Cole',
			            'John Terry',            'Rio Ferdinand',
			            'Glen Johnson',
			            'Joe Cole',
			            'Steven Gerrard',
			            'Frank Lampard',            'David Beckham',
			            'Wayne Rooney',
			            'Michael Owen',
			        );
			
		}

	 	/**
	     * The list action is the default for the rest controller
	     * Forward to index
	     */ 
	
	    public function listAction()
	    {
			$this->getResponse ()->setHeader ( 'Content-Type', 'text/xml' );
			$usersModel = new Model_User(); 
	  		$user = $usersModel->fetchUsers();
			if ($user == null){
			}
			else{
			 	print $this->_handleStruct($user);	
			}	   
		}

	    /**
	     * The get action handles GET requests and receives an 'id' parameter; it 
	     * should respond with the server resource state of the resource identified
	     * by the 'id' value.
	     * 
		 * VIEW A USER
	     */ 
	
	    public function getAction()
	    {
		//	$this->getResponse ()->setHeader ( 'Content-Type', 'text/xml' );
			$params = $this->_getAllParams();
			$query = $this->getRequest()->getParam('id');
			$usersModel = new Model_User(); 
	//	  	$user = $usersModel->fetchUser($query);
	// 
			$user = $usersModel->fetchUsers();
  	
			if ($user == null){
				$this->result_code = '0';
				$this->result_action = 'Not Found';
			}
			else{
				$this->result_code = '1';
				$this->result_action = 'View User';
			}
			
			$this->view->users = $user;
	/*		$this->view->team = 'a';
			        $this->view->players = array(
			            'David James',
			            'Ashley Cole',
			            'John Terry',            'Rio Ferdinand',
			            'Glen Johnson',
			            'Joe Cole',
			            'Steven Gerrard',
			            'Frank Lampard',            'David Beckham',
			            'Wayne Rooney',
			            'Michael Owen',
			        );	
			
			*/
		//	$badges = new Model_Achievement(); 
		//	$badges = $badges->fetchAchievements($query);
			$this->_forward('index');
	//		print $this->_handleStruct($user);	
	//		print $this->_handleStructComposite($user, $badges);	
			
		}

	    /**
	     * The post action handles POST requests; it should accept and digest a
	     * POSTed resource representation and persist the resource state.
	     * 
		 * ADD OR UPDATE A USER
	     */
	
	    public function postAction() {
			//$method = (isset($_SERVER['HTTP_X_HTTP_METHOD_OVERRIDE'])) ? $_SERVER['HTTP_X_HTTP_METHOD_OVERRIDE'] : $_SERVER['REQUEST_METHOD'];
			$this->getResponse ()->setHeader ( 'Content-Type', 'text/xml' );
			$usersModel = new Model_User(); 
			$params = $this->_getAllParams();
			unset($params['controller']);
	        unset($params['action']);
	        unset($params['module']);
			$uid = $this->getRequest()->getParam('uid');
			$name = $this->getRequest()->getParam('name');
			$email = $this->getRequest()->getParam('email');
			$gender = $this->getRequest()->getParam('gender');
			$birthday = $this->getRequest()->getParam('birthday');
			$location = $this->getRequest()->getParam('location');
			$profile_photo = 'user_profile_photo/user_'.$uid.'.jpg';
			$alpinized_photo = null;
			$style = null;
			$user = $usersModel->addUser(null, $uid, $name, $email, $gender, $birthday, $location, $profile_photo, $alpinized_photo, null, null, null, null);
			print $this->_handleStruct($user);
	    }

	    /**
	     * The put action handles PUT requests and receives an 'id' parameter; it 
	     * should update the server resource state of the resource identified by 
	     * the 'id' value.
	     */  
	    public function putAction() {
			$this->getResponse ()->setHeader ( 'Content-Type', 'text/xml' );
			$params = $this->_getAllParams();
			$id = $this->getRequest()->getParam('id');
			unset($params['controller']);
	        unset($params['action']);
	        unset($params['id']);
	        unset($params['module']);
			$usersModel = new Model_User(); 
		  	$user = $usersModel->updateUser($id, $params);
			if ($id == null){
				$this->result_code = '0';
			}
			else{
				$this->result_code = '1';
			}
		 	print $this->_handleStruct($user);
	    }

	    /**
	     * The delete action handles DELETE requests and receives an 'id' 
	     * parameter; it should update the server resource state of the resource
	     * identified by the 'id' value.
	     */  
	
	    public function deleteAction() {
			$this->_forward('index');
		}
	
				protected function _handleStruct($struct) {

					$dom = new DOMDocument ( '1.0', 'UTF-8' );

					$root = $dom->createElement ( "Alpinizer" );
					$method = $root;

					$root->setAttribute ( 'generator', $this->result_action );
					$root->setAttribute ( 'version', '1.0' );
					$dom->appendChild ( $root );

					$struct = ( array ) $struct;
					if (! isset ( $struct ['status'] )) {
						$status = $dom->createElement ( 'Method', $this->result_code );
						$method->appendChild ( $status );
					}

					$this->_structValue($struct, $dom, $method );
					return $dom->saveXML ();
				}

				protected function _handleStructComposite($struct, $struct2) {

					$dom = new DOMDocument ( '1.0', 'UTF-8' );

					$root = $dom->createElement ( "Alpinizer" );
					$method = $root;

					$root->setAttribute ( 'generator', $this->result_action );
					$root->setAttribute ( 'version', '1.0' );
					$dom->appendChild ( $root );

					$struct = ( array ) $struct;
					if (! isset ( $struct ['status'] )) {
						$status = $dom->createElement ( 'Method', $this->result_code );
						$method->appendChild ( $status );
					}

					$this->_structValue($struct, $dom, $method );

					$objParent = $dom->createElement ('Achievements');
					$root->appendChild ($objParent);

					$this->_structValueChildren($struct2, $dom, $objParent );
					return $dom->saveXML ();
				}

				/**
				 * Recursively iterate through a struct
				 *
				 * Recursively iterates through an associative array or object's properties
				 * to build XML response.
				 *
				 * @param mixed $struct
				 * @param DOMDocument $dom
				 * @param DOMElement $parent
				 * @return void
				 */
				protected function _structValue($struct, DOMDocument $dom, DOMElement $parent) {
					$struct = ( array ) $struct;

					foreach ( $struct as $key => $value ) {
						if ($value === false) {
							$value = 0;
						} elseif ($value === true) {
							$value = 1;
						}

						if (ctype_digit ( ( string ) $key )) {
							$key = 'Level';
						}

						if (is_array ( $value ) || is_object ( $value )) {
							$element = $dom->createElement ( $key );
							$this->_structValue ( $value, $dom, $element );
						} else {
							$element = $dom->createElement ( $key );
							$element->appendChild ( $dom->createTextNode ( $value ) );
						}

						$parent->appendChild ( $element );
					}
				}

				protected function _structValueChildren($struct, DOMDocument $dom, DOMElement $parent) {
					$struct = ( array ) $struct;

					foreach ( $struct as $key => $value ) {
						if ($value === false) {
							$value = 0;
						} elseif ($value === true) {
							$value = 1;
						}

						if (ctype_digit ( ( string ) $key )) {
							$key = 'Achievement';
						}

						if (is_array ( $value ) || is_object ( $value )) {
							$element = $dom->createElement ( $key );
							$this->_structValue ( $value, $dom, $element );
						} else {
							$element = $dom->createElement ( $key );
							$element->appendChild ( $dom->createTextNode ( $value ) );
						}

						$parent->appendChild ( $element );
					}
				}



		}
