<?php
class ArticleController extends Zend_Rest_Controller
{

    public function init()
    {
        $this->_helper->viewRenderer->setNoRender(true);
    }

 public function indexAction()
 {
		$usersModel = new User(); 
		
		//$users->fetchUsers();
		
	         $this->getResponse()
	            ->appendBody("From indexAction() returning all articles");
 }

 public function getAction()
    {
        $this->getResponse()
            ->appendBody("From getAction() returning the requested article");

    }

    public function postAction()
    {
        $this->getResponse()
            ->appendBody("From postAction() creating the requested article");

    }

    public function putAction()
    {
        $this->getResponse()
            ->appendBody("From putAction() updating the requested article");

    }

    public function deleteAction()
    {
        $this->getResponse()
            ->appendBody("From deleteAction() deleting the requested article");

    }

}
?>