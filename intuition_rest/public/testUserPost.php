<?php
/**
*
* THIS IS AN EXAMPLE AS HOW TO CALL A REST CALL - POST METHOD
*/
$url = 'http://localhost/alpinizer4/public/user/';

$data = array(
	'id' => '1',
	'name' => 'isaac silva', 
	'birthday' => 'aaa'
);

$ch = curl_init();
//$headers[] = array('apikey' => 'secret');
curl_setopt($ch,CURLOPT_URL,$url);
//curl_setopt($ch, CURLOPT_HTTPHEADER, array("apikey: secret")); // this is for the API key
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch,CURLOPT_POST,'');
curl_setopt($ch,CURLOPT_POSTFIELDS,$data);
$result = curl_exec($ch);
curl_close($ch);
echo($result);




?>