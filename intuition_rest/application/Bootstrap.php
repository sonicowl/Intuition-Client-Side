<?php

class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{


	protected function _initAutoload(){
		$autoLoader = Zend_Loader_Autoloader::getInstance();
		$resourceLoader = new Zend_Loader_Autoloader_Resource(array(
			'basePath'	=> APPLICATION_PATH,
			'namespace'	=> '',
			'resourceTypes' => array(
				'form' => array(
					'path'	=> 'forms/',
					'namespace' => 'Form_',
				),
				'model' => array(
					'path'	=> 'models/',
					'namespace' => 'Model_'
				),
			),
		));		
		return $autoLoader;
		
	} 

	
	protected function _initRestRoute()
	{
	        $this->bootstrap('frontController');
	        $frontController = Zend_Controller_Front::getInstance();
	        $restRoute = new Zend_Rest_Route($frontController);
	        $frontController->getRouter()->addRoute('default', $restRoute);

	}
	
	

}



