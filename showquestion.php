<?php
$mysql_access = mysql_connect("localhost", "root", "cigano");
mysql_select_db ("Intuition");
$query = "select * from intuition where id=".rand(1,3750);
$result = mysql_query($query, $mysql_access);
$row = mysql_fetch_row($result);

echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">";

echo "<html>";
echo "<body>";
echo "<h1>Intuition</h1>";
echo "<form name='intuition'>";

echo "<b>".$row[1]."</b><br><br>";
echo "<input type='radio' name='question' value='1'/>&nbsp;".$row[7]."&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' value='".base64_encode($row[19])."' name='answer1'>&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' name='score1' style='border: none'><br><br>";
echo "<input type='radio' name='question' value='2'/>&nbsp;".$row[8]."&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' value='".base64_encode($row[20])."' name='answer2'>&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' name='score2' style='border: none'><br><br>";
echo "<input type='radio' name='question' value='3'/>&nbsp;".$row[9]."&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' value='".base64_encode($row[21])."' name='answer3'>&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' name='score3' style='border: none'><br><br>";
echo "<input type='radio' name='question' value='4'/>&nbsp;".$row[10]."&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' value='".base64_encode($row[22])."' name='answer4'>&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' name='score4' style='border: none'><br><br>";
echo "<input type='radio' name='question' value='5'/>&nbsp;".$row[11]."&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' value='".base64_encode($row[23])."' name='answer5'>&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' name='score5' style='border: none'><br><br>";
echo "<input type='radio' name='question' value='6'/>&nbsp;".$row[12]."&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' value='".base64_encode($row[24])."' name='answer6'>&nbsp;&nbsp;<input type=text style=\"visibility:hidden\" size='2' name='score6' style='border: none'><br><br>";


echo "<input type=BUTTON value='Submit' name='mySubmit' onClick='showresults();'><br><br><br>";
echo "Current Score: <input type=text size='2' name='score' style='border: none'><br><br>";
echo "<b>Record: </b><input type=text size='2' name='highscore' style='border: none'>";


echo "<script type=\"text/javascript\" src='base.js'></script>";

echo "<script type=\"text/javascript\">";


echo "function getCheckedValue(radioObj) {";
echo "	if(!radioObj)";
echo "		return \"\";";
echo "	var radioLength = radioObj.length;";
echo "	if(radioLength == undefined)";
echo "		if(radioObj.checked)";
echo "			return radioObj.value;";
echo "		else";
echo "			return \"\";";
echo "	for(var i = 0; i < radioLength; i++) {";
echo "		if(radioObj[i].checked) {";
echo "			return radioObj[i].value;";
echo "		}";
echo "	}";
echo "	return \"\";";
echo "}";



echo "function showresults() {";

echo "if (document.intuition.mySubmit.value=='Submit') { ";

echo "if (getCheckedValue(document.intuition.question)=='') {alert('Select a answer'); return;} ";


echo "document.intuition.mySubmit.value='Next';";

echo "document.intuition.answer1.value=decode(document.intuition.answer1.value);";
echo "document.intuition.answer2.value=decode(document.intuition.answer2.value);";
echo "document.intuition.answer3.value=decode(document.intuition.answer3.value);";
echo "document.intuition.answer4.value=decode(document.intuition.answer4.value);";
echo "document.intuition.answer5.value=decode(document.intuition.answer5.value);";
echo "document.intuition.answer6.value=decode(document.intuition.answer6.value);";
echo "document.intuition.answer1.style.visibility = 'visible';";
echo "document.intuition.answer2.style.visibility = 'visible';";
echo "document.intuition.answer3.style.visibility = 'visible';";
echo "document.intuition.answer4.style.visibility = 'visible';";
echo "document.intuition.answer5.style.visibility = 'visible';";
echo "document.intuition.answer6.style.visibility = 'visible';";
echo "document.intuition.score1.style.visibility = 'visible';";
echo "document.intuition.score2.style.visibility = 'visible';";
echo "document.intuition.score3.style.visibility = 'visible';";
echo "document.intuition.score4.style.visibility = 'visible';";
echo "document.intuition.score5.style.visibility = 'visible';";
echo "document.intuition.score6.style.visibility = 'visible';";

echo "var contador1 = 0;";
echo "if (Number(document.intuition.answer1.value) < Number(document.intuition.answer2.value)) contador1 = contador1 + 1;";
echo "if (Number(document.intuition.answer1.value) < Number(document.intuition.answer3.value)) contador1 = contador1 + 1;";
echo "if (Number(document.intuition.answer1.value) < Number(document.intuition.answer4.value)) contador1 = contador1 + 1;";
echo "if (Number(document.intuition.answer1.value) < Number(document.intuition.answer5.value)) contador1 = contador1 + 1;";
echo "if (Number(document.intuition.answer1.value) < Number(document.intuition.answer6.value)) contador1 = contador1 + 1;";

echo "var contador2 = 0;";
echo "if (Number(document.intuition.answer2.value) < Number(document.intuition.answer1.value)) contador2 = contador2 + 1;";
echo "if (Number(document.intuition.answer2.value) < Number(document.intuition.answer3.value)) contador2 = contador2 + 1;";
echo "if (Number(document.intuition.answer2.value) < Number(document.intuition.answer4.value)) contador2 = contador2 + 1;";
echo "if (Number(document.intuition.answer2.value) < Number(document.intuition.answer5.value)) contador2 = contador2 + 1;";
echo "if (Number(document.intuition.answer2.value) < Number(document.intuition.answer6.value)) contador2 = contador2 + 1;";

echo "var contador3 = 0;";
echo "if (Number(document.intuition.answer3.value) < Number(document.intuition.answer1.value)) contador3 = contador3 + 1;";
echo "if (Number(document.intuition.answer3.value) < Number(document.intuition.answer2.value)) contador3 = contador3 + 1;";
echo "if (Number(document.intuition.answer3.value) < Number(document.intuition.answer4.value)) contador3 = contador3 + 1;";
echo "if (Number(document.intuition.answer3.value) < Number(document.intuition.answer5.value)) contador3 = contador3 + 1;";
echo "if (Number(document.intuition.answer3.value) < Number(document.intuition.answer6.value)) contador3 = contador3 + 1;";

echo "var contador4 = 0;";
echo "if (Number(document.intuition.answer4.value) < Number(document.intuition.answer1.value)) contador4 = contador4 + 1;";
echo "if (Number(document.intuition.answer4.value) < Number(document.intuition.answer2.value)) contador4 = contador4 + 1;";
echo "if (Number(document.intuition.answer4.value) < Number(document.intuition.answer3.value)) contador4 = contador4 + 1;";
echo "if (Number(document.intuition.answer4.value) < Number(document.intuition.answer5.value)) contador4 = contador4 + 1;";
echo "if (Number(document.intuition.answer4.value) < Number(document.intuition.answer6.value)) contador4 = contador4 + 1;";

echo "var contador5 = 0;";
echo "if (Number(document.intuition.answer5.value) < Number(document.intuition.answer1.value)) contador5 = contador5 + 1;";
echo "if (Number(document.intuition.answer5.value) < Number(document.intuition.answer2.value)) contador5 = contador5 + 1;";
echo "if (Number(document.intuition.answer5.value) < Number(document.intuition.answer3.value)) contador5 = contador5 + 1;";
echo "if (Number(document.intuition.answer5.value) < Number(document.intuition.answer4.value)) contador5 = contador5 + 1;";
echo "if (Number(document.intuition.answer5.value) < Number(document.intuition.answer6.value)) contador5 = contador5 + 1;";

echo "var contador6 = 0;";
echo "if (Number(document.intuition.answer6.value) < Number(document.intuition.answer1.value)) contador6 = contador6 + 1;";
echo "if (Number(document.intuition.answer6.value) < Number(document.intuition.answer2.value)) contador6 = contador6 + 1;";
echo "if (Number(document.intuition.answer6.value) < Number(document.intuition.answer3.value)) contador6 = contador6 + 1;";
echo "if (Number(document.intuition.answer6.value) < Number(document.intuition.answer4.value)) contador6 = contador6 + 1;";
echo "if (Number(document.intuition.answer6.value) < Number(document.intuition.answer5.value)) contador6 = contador6 + 1;";



echo "if (Number(contador1) == 0) document.intuition.score1.value = '100';";
echo "if (Number(contador1) == 1) document.intuition.score1.value = '50';";
echo "if (Number(contador1) == 2) document.intuition.score1.value = '10';";
echo "if (Number(contador1) == 3) document.intuition.score1.value = '5';";
echo "if (Number(contador1) == 4) document.intuition.score1.value = '1';";
echo "if (Number(contador1) == 5) document.intuition.score1.value = 'reset';";


echo "if (Number(contador2) == 0) document.intuition.score2.value = '100';";
echo "if (Number(contador2) == 1) document.intuition.score2.value = '50';";
echo "if (Number(contador2) == 2) document.intuition.score2.value = '10';";
echo "if (Number(contador2) == 3) document.intuition.score2.value = '5';";
echo "if (Number(contador2) == 4) document.intuition.score2.value = '1';";
echo "if (Number(contador2) == 5) document.intuition.score2.value = 'reset';";



echo "if (Number(contador3) == 0) document.intuition.score3.value = '100';";
echo "if (Number(contador3) == 1) document.intuition.score3.value = '50';";
echo "if (Number(contador3) == 2) document.intuition.score3.value = '10';";
echo "if (Number(contador3) == 3) document.intuition.score3.value = '5';";
echo "if (Number(contador3) == 4) document.intuition.score3.value = '1';";
echo "if (Number(contador3) == 5) document.intuition.score3.value = 'reset';";


echo "if (Number(contador4) == 0) document.intuition.score4.value = '100';";
echo "if (Number(contador4) == 1) document.intuition.score4.value = '50';";
echo "if (Number(contador4) == 2) document.intuition.score4.value = '10';";
echo "if (Number(contador4) == 3) document.intuition.score4.value = '5';";
echo "if (Number(contador4) == 4) document.intuition.score4.value = '1';";
echo "if (Number(contador4) == 5) document.intuition.score4.value = 'reset';";


echo "if (Number(contador5) == 0) document.intuition.score5.value = '100';";
echo "if (Number(contador5) == 1) document.intuition.score5.value = '50';";
echo "if (Number(contador5) == 2) document.intuition.score5.value = '10';";
echo "if (Number(contador5) == 3) document.intuition.score5.value = '5';";
echo "if (Number(contador5) == 4) document.intuition.score5.value = '1';";
echo "if (Number(contador5) == 5) document.intuition.score5.value = 'reset';";


echo "if (Number(contador6) == 0) document.intuition.score6.value = '100';";
echo "if (Number(contador6) == 1) document.intuition.score6.value = '50';";
echo "if (Number(contador6) == 2) document.intuition.score6.value = '10';";
echo "if (Number(contador6) == 3) document.intuition.score6.value = '5';";
echo "if (Number(contador6) == 4) document.intuition.score6.value = '1';";
echo "if (Number(contador6) == 5) document.intuition.score6.value = 'reset';";

echo "if (Get_Cookie('Score') == '') Set_Cookie('Score',Number(0),30, '/', '', '');";
echo "if (Get_Cookie('HighScore') == '') Set_Cookie('HighScore',Number(0),30, '/', '', '');";

echo "document.intuition.score1.style.color = 'black';";
echo "document.intuition.score2.style.color = 'black';";
echo "document.intuition.score3.style.color = 'black';";
echo "document.intuition.score4.style.color = 'black';";
echo "document.intuition.score5.style.color = 'black';";
echo "document.intuition.score6.style.color = 'black';";

echo "if (getCheckedValue(document.intuition.question) == 1) {document.intuition.score1.style.color = 'red';document.intuition.score1.style.fontWeight = 'bold'; if (document.intuition.score1.value=='reset') Set_Cookie('Score',Number(0),30, '/', '', ''); else Set_Cookie('Score',Number(Get_Cookie('Score'))+Number(document.intuition.score1.value),30, '/', '', '');}";
echo "if (getCheckedValue(document.intuition.question) == 2) {document.intuition.score2.style.color = 'red'; document.intuition.score1.style.fontWeight = 'bold';if (document.intuition.score2.value=='reset') Set_Cookie('Score',Number(0),30, '/', '', ''); else Set_Cookie('Score',Number(Get_Cookie('Score'))+Number(document.intuition.score2.value),30, '/', '', '');}";
echo "if (getCheckedValue(document.intuition.question) == 3) {document.intuition.score3.style.color = 'red'; document.intuition.score1.style.fontWeight = 'bold';if (document.intuition.score3.value=='reset') Set_Cookie('Score',Number(0),30, '/', '', ''); else Set_Cookie('Score',Number(Get_Cookie('Score'))+Number(document.intuition.score3.value),30, '/', '', '');}";
echo "if (getCheckedValue(document.intuition.question) == 4) {document.intuition.score4.style.color = 'red'; document.intuition.score1.style.fontWeight = 'bold';if (document.intuition.score4.value=='reset') Set_Cookie('Score',Number(0),30, '/', '', ''); else Set_Cookie('Score',Number(Get_Cookie('Score'))+Number(document.intuition.score4.value),30, '/', '', '');}";
echo "if (getCheckedValue(document.intuition.question) == 5) {document.intuition.score5.style.color = 'red'; document.intuition.score1.style.fontWeight = 'bold';if (document.intuition.score5.value=='reset') Set_Cookie('Score',Number(0),30, '/', '', ''); else Set_Cookie('Score',Number(Get_Cookie('Score'))+Number(document.intuition.score5.value),30, '/', '', '');}";
echo "if (getCheckedValue(document.intuition.question) == 6) {document.intuition.score6.style.color = 'red'; document.intuition.score1.style.fontWeight = 'bold'; if (document.intuition.score6.value=='reset') Set_Cookie('Score',Number(0),30, '/', '', ''); else Set_Cookie('Score',Number(Get_Cookie('Score'))+Number(document.intuition.score6.value),30, '/', '', '');}";
echo "if (Number(Get_Cookie('Score')) > Number(Get_Cookie('HighScore'))) Set_Cookie('HighScore',Number(Get_Cookie('Score')),30, '/', '', '');"; 

echo "} else { ";

echo "document.intuition.submit(); ";


echo "}  "; 
echo "document.intuition.score.value = Get_Cookie('Score');";
echo "document.intuition.highscore.value = Get_Cookie('HighScore');";
echo "} ";
echo "document.intuition.score.value = Get_Cookie('Score');";
echo "document.intuition.highscore.value = Get_Cookie('HighScore');";
echo "</script>";





echo "</form>";

echo "</body>";
echo "</html>";

?>