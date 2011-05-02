<?php 

class Model_Question extends Zend_Db_Table_Abstract {
	
	protected $_name = 'Question';

	public function addQuestion($id = NULL, $mtvid = NULL, $facebookid = NULL, $name = NULL, $gamelevel = NULL, $scorevalue = NULL, $gamecenterid = NULL, $longitude = NULL, $latitude = NULL, $date = NULL)
	{
	    $data = array(
			'id' => $id, 
			'mtvid' => $mtvid,
			'facebookid' => $facebookid,
			'name' => $name,
			'gamelevel' => $gamelevel,
			'scorevalue' => $scorevalue,
			'gamecenterid' => $gamecenterid,
			'longitude' => $longitude,
			'latitude' => $latitude,
			'date' => $date
		);
		$this->insert($data);
		$id = $this->_db->lastInsertId();
		return $id;
	}
	
	public function updateQuestion($id, $attributes)
	{
		$id = (int)$id;
		$this->update($attributes, 'id = '.(int)$id);
		return $id;
	}

	public function deleteQuestion($id)
	{
		$id = (int)$id;
		$this->delete('id = '.(int)$id);
	}
	
	public function fetchQuestions(){
		$select = $this->select()
		              ->from('Question')
					  ->order('rand()')
					  ->limit('30')
					  ->setIntegrityCheck(false);
		return $this->fetchAll($select)->toArray();
	}

	public function fetchQuestionsByTime($time){
		/* time variable not implemented yet */

	}
	
	public function fetchFacebookFriends($id){
		$select = $this->select()
		              ->from('record')
					  ->where('facebookid = '.$id)					  
					  ->setIntegrityCheck(false);
		return $this->fetchAll($select)->toArray();
	}
	
	
	public function fetchQuestionScore($id){

	}
	


} 


?>