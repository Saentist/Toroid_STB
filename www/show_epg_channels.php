<?
/* Toroid -- An open source middleware for IPTV deployments.
 *
 * Copyright (C) 2007 - 2008, Linopoly, Inc
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
$section = "EPG Data";
$smarty->assign("title","Toroid - $section");


//Start the display of table for channels
//Check orderby get variable.  We should probably sanitize this.
if ($_GET[orderby]) {
	$orderby = " ORDER by $_GET[orderby] ASC";
}

//Get Result
$query = "SELECT * FROM ".$toroid['db']['prepend']."epg_channels".$orderby;
$result =& $db->query($query);

//Run Pager Wrapper Against It
$paged_data = Pager_Wrapper_MDB2($db, $query, $pager_options);

$body .= <<<END
                <h2>${section} Channels</h2>
		{$paged_data['links']}
                <table cellpadding=1 cellspacing=0 border=1 width=100%>
                <tr>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=id">id</a></td>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=name">name</a></td>
                </tr>
END;

foreach($paged_data['data'] as $row) {
$body .= <<<END
                <tr>
                        <td>{$row['id']}</td>
                        <td>{$row['name']}</td>
                </tr>

END;
}
$body .= "</table>";

	$smarty->assign("results",$result);
        $smarty->assign("body",$body);
        $smarty->display($toroid['template']);
}

//Cleanup.
include('includes/bootclose.php');
?>
