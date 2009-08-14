<?
/* Toroid -- An open source middleware for IPTV deployments.
 *
 * Copyright (C) 2007 - 2008, Linopoly, LLC
 *
 * This program is free software, distributed under the terms of the GNU
 * General Public License Version 2.  Please see the LICENSE file at the top
 * of the source tree.
 *
 * Brian McManus <bmcmanus@gmail.com>
 */

//Include required usuals
include('includes/bootstrap.php');

//Check Authentication
if ($auth->getAuth()) {
$section = "Operators";
$table = strtolower($section);
$smarty->assign("title","Toroid - $section Configuration");


//We're logged in allow actions

//Proccess actions we may have submitted to ourselves.
//If there is a POST, put to database and show 'locked' form.
if ($_POST[Submit] == "Add")
{
        putFormDB($toroid['db']['prepend'].$table, $_POST);
        $smarty->assign("successmenu","<p class=\"new\"><a href=\"$_SERVER[PHP_SELF]\">Add new $section</a></p>");
        $smarty->assign("successmessage", "<BR /><h3 class=\"success\">$section Added</h3><br />");
        $smarty->assign("formlock",1);
} else if ($_POST[Submit] == "Save") {
        updateFormDB($toroid['db']['prepend'].$table, $_POST);
        $smarty->assign("successmenu","<p class=\"new\"><a href=\"$_SERVER[PHP_SELF]\">Add new $section</a></p>");
        $smarty->assign("successmessage", "<BR /><h3 class=\"success\">$section Updated</h3><br />");
        $smarty->assign("formlock",1);
}

//Check GET Actions
if($_GET[action] == 'delete') {
$query = "DELETE FROM " .$toroid['db']['prepend']."$table WHERE id=$_GET[id]";
$db->query($query);
} else if($_GET[action] == 'edit') {
        $smarty->assign("formlock",0);
	$smarty->assign("formname","Edit $section");
	$query = "SELECT * FROM ".$toroid['db']['prepend']."$table WHERE id=$_GET[id]";
	$edit = $db->getRow($query);
} else if ($_GET[action] == 'show') {
	$smarty->assign("formlock",1);
	$smarty->assign("formname","Show $section");
	$query = "SELECT * FROM ".$toroid['db']['prepend']."$table WHERE id=$_GET[id]";
	$edit = $db->getRow($query);
} else {

	$smarty->assign("formname","Add $section");
}


//Start the display of table
//Check orderby get variable.  We should probably sanitize this.
if ($_GET[orderby]) {
	$orderby = " ORDER by $_GET[orderby] ASC";
}

//Get Result
$query = "SELECT * FROM ".$toroid['db']['prepend'].$table.$orderby;
$result =& $db->query($query);

//Run Pager Wrapper Against It
$paged_data = Pager_Wrapper_MDB2($db, $query, $pager_options);

$body .= <<<END
                <h2>{$section}</h2>
		{$paged_data['links']}
                <table cellpadding=1 cellspacing=0 border=1 width=100%>
                <tr>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=id">id</a></td>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=username">username</a></td>
			<td><a href="{$_SERVER[PHP_SELF]}?orderby=firstname">firstname</a></td>
			<td><a href="{$_SERVER[PHP_SELF]}?orderby=lastname">lastname</a></td>
			<td><a href="{$_SERVER[PHP_SELF]}?orderby=email">email</a></td>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=enabled">enabled</a></td>
                        <td>actions</td>
                </tr>
END;


foreach($paged_data['data'] as $row) {
$body .= <<<END
                <tr>
                        <td>{$row[id]}</td>
                        <td>{$row[username]}</td>
                        <td>{$row[firstname]}</td>
                        <td>{$row[lastname]}</td>
                        <td>{$row[email]}</td>
                        <td>{$row[enabled]}</td>
                        <td>&nbsp;<a href="{$_SERVER[PHP_SELF]}?action=show&id={$row[id]}"><img src="images/show.png" border="0" alt="show"></a><a href="{$_SERVER[PHP_SELF]}?action=edit&id={$row[id]}"><img src="images/edit.png" border="0" alt="edit"></a><a href="{$_SERVER[PHP_SELF]}?action=delete&id={$row[id]}">&nbsp;&nbsp;<img src="images/delete.png" border="0" alt="delete"></a></td>
                </tr>

END;
}
$body .= "</table>";

//Render the the system status module
if($_GET[action] != null) {
	$buttonValue = "Save"; 
} else {
	$buttonValue = "Add";
}
	$form = array(
			array('label' => '', 'type' => 'hidden', 'name' => 'id', 'value' => $edit[id]),
			array('label' => "$section Username", 'type' => 'text', 'name' => 'username', 'value' => $edit[username], 'size' => 20),
			array('label' => "$section E-Mail", 'type' => 'text', 'name' => 'email', 'value' => $edit[email], 'br' => '<BR />'),
			array('label' => 'First Name', 'type' => 'text', 'name' => 'firstname', 'value' => $edit[firstname]),
			array('label' => 'Last Name', 'type' => 'text', 'name' => 'lastname', 'value' => $edit[lastname], 'br' => '<BR />'),
			array('label' => 'Password', 'type' => 'text', 'name' => 'password', 'br' => '<BR />'),
			array('label' => 'Enabled', 'type' => 'text', 'name' => 'enabled', 'size' => 1, 'value' => $edit[enabled]),

			array('label' => '', 'type' => 'submit', 'name' => 'Submit', 'value' => $buttonValue)
		);
	
        if($_POST[Submit] != null) {
	// Dont show form again if there was a recent submit (like an edit or add)
	} else {
		$smarty->assign("form",1);
		$smarty->assign("formdata",$form);
	}

	$smarty->assign("results",$result);
        $smarty->assign("body",$body);
        $smarty->display($toroid['template']);
}

//Cleanup.
include('includes/bootclose.php');
?>
