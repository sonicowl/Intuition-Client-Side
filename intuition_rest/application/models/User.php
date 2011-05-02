<?php 

class Model_User extends Zend_Db_Table_Abstract {
	
	protected $_name = 'user';
	protected $_primary = 'id';
	protected $_dependentTables = array('Model_Level');
	
	
	/*	
	
	public function __construct() {
		$this->db = new PDO('mysql:dbname=alpinizer;host=localhost', 'root', 'root');
	}
	
	*/
	
	/*
	
	public function fetchUser($id) {
		$rs = $this->db->query("SELECT * FROM user WHERE id = $id"); 
		return $rs->fetchAll(PDO::FETCH_ASSOC);
	} 
	
	*/
	
	public function addUser($id = NULL, $uid = NULL, $name = NULL, $email = NULL, $gender = NULL, $birthday = NULL, $location = NULL, $profile_photo = NULL, $alpinized_photo = NULL, $registration_date = NULL, $score = NULL, $last_completed_level_id = NULL, $style = NULL)
	{
	    $data = array(
			'id' => $id, 
			'uid' => $uid,
			'name' => $name,
			'email' => $email,
			'gender' => $gender,
			'birthday' => $birthday,
			'location' => $location,
			'profile_photo' => $profile_photo,
			'alpinized_photo' => $alpinized_photo,
			'registration_date' => $registration_date,
			'score' => $score,
			'last_completed_level_id' => $last_completed_level_id,
			'style' => $style
		);
		$this->insert($data);
		$id = $this->_db->lastInsertId();
		return $id;
	}
	
	public function updateUser($id, $attributes)
	{
		$id = (int)$id;
		
	/*	$data = array(
			'name'=> 'isaac4',
			'birthday'=> '1'
		); */
	
		$this->update($attributes, 'id = '.(int)$id);
		return $id;
	}
	
	public function deleteUser($id)
	{
		$id = (int)$id;
		$this->delete('id = '.(int)$id);
	}
	
	public function fetchUser($id){
		$id = (int)$id;
		$row = $this->fetchRow('id = '.$id);
		if(!$row){
			return NULL;
		}
		else{
			return $row->toArray();
		}
	}
	
	public function fetchUserProfile($uid){
		$uid = (int)$uid;
		$row = $this->fetchRow('uid = '.$uid);
		if(!$row){
			return NULL;
		}
		else{
			return $row->toArray();
		}
	}
	
	public function fetchUsers(){
		$row = $this->fetchAll();
		return $row->toArray();
	}
	
	public function fetchUserScore($id){
		$select = $this->select()
		              ->from(array('u' => 'user'), array('score', 'last_completed_level_id'))
					  ->where('id = '.$id)
					  ->setIntegrityCheck(false);
		return $this->fetchAll($select)->toArray();
	}
	
	public function fetchUserFriends($id){
		$select = $this->select()
		    		  ->from(array('i' => 'invited_friends'), array('invitee_uid', 'owner_uid'))
		              ->join(array('u' => 'user'), 'u.uid = i.invitee_uid', array('u.id as invitee_id','u.name as invitee_name', 'u.profile_photo as invitee_profile_photo'))
					  ->where('i.owner_uid = '.$id)
					  ->setIntegrityCheck(false);
		return $this->fetchAll($select)->toArray();
	}

} 


?>