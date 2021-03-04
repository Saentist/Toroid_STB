<?php
/* Toroid -- An open source middleware for IPTV deployments.
 *
 * Copyright (C) 2007 - 2008, Linopoly, LLC
 *
 * This program is free software, distributed under the terms of the GNU
 * General Public License Version 2.  Please see the LICENSE file at the top
 * of the source tree.
 */

/* What is this file?
 * All functions required for underlying applications.
 */


function toroidLogin() {
echo 'login';
}

function putFormDB($table, $form) {
//This is a handy function that parses through the $_POST array and grabs keys and values and generates
//an INSERT statement.
global $db;

$count = count($form);
  foreach ($form as $key => $value) {
	    	$$key = addslashes(trim($value));
	if ($i < $count-2) {
			if ($key == "password") {
				$names .= $key.",";
				$values .= "md5('$value'),";
			} else {
				$names .= $key.",";
				$values .= "'$value',";
			}

	} else {
		if ($i < $count-1) {
		$names .= $key;
		$values .= "'$value'";
		} else {
			//Dont insert submit form button
		}
	}
	$i++;
  }
$query = "INSERT INTO $table ($names) VALUES ($values)";
$db->query($query);
}

function updateFormDB($table, $form) {
//This is a handy function that parses through the $_POST array and grabs keys and values and generates
//an INSERT statement.
global $db;

$count = count($form);
  foreach ($form as $key => $value) {
	    	$$key = addslashes(trim($value));
	if ($i < $count-2) {
		if($key == "id") {
			$id = $value;
		} else if ($key == "password") {
			if($value == "") {
			//do nothing if they didnt update the password
			} else {
			$values .= "$key=md5('$value'),";
			}
		} else {
		$values .= "$key='$value',";
		}
	} else {
		if ($i < $count-1) {
		$values .= "$key='$value'";
		} else {
			//Dont insert submit form button
		}
	}
	$i++;
  }
$query = "UPDATE $table SET $values WHERE id=$id";
$db->query($query);
}

?>
