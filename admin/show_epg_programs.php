<?php
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
$section = "EPG Data";
$smarty->assign("title","Toroid - $section");

//Parse GET[actions]
 if ($_GET['action'] == 'show') {
        $smarty->assign("formlock",1);
        $smarty->assign("formname","Show $section");
        $query = "SELECT * FROM ".$toroid['db']['prepend']."epg_programs WHERE id=$_GET[id]";
        $edit = $db->getRow($query);
}

//Start the display of table for channels
//Check orderby get variable.  We should probably sanitize this.
if ($_GET[orderby]) {
	$orderby = " ORDER by $_GET[orderby] ASC";
}

//Get Result
$query = "SELECT * FROM ".$toroid['db']['prepend']."epg_programs".$orderby;
$result =& $db->query($query);

//Run Pager Wrapper Against It
$paged_data = Pager_Wrapper_MDB2($db, $query, $pager_options);

$body .= <<<END
                <h2>${section} Programs</h2>
		{$paged_data['links']}
                <table cellpadding=1 cellspacing=0 border=1 width=100%>
                <tr>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=id">id</a></td>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=title">title</a></td>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=start">start</a></td>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=stop">stop</a></td>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=date">date</a></td>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=category">category</a></td>
                        <td><a href="{$_SERVER[PHP_SELF]}?orderby=rating_vchip">rating_vchip</a></td>
			<td>&nbsp;</td>
                </tr>
END;

foreach($paged_data['data'] as $row) {
$body .= <<<END
                <tr>
                        <td>{$row['id']}</td>
                        <td>{$row['title']}</td>
                        <td>{$row['start']}</td>
                        <td>{$row['stop']}</td>
                        <td>{$row['date']}</td>
                        <td>{$row['category']}</td>
                        <td>{$row['rating_vchip']}</td>
			<td><a href="{$_SERVER[PHP_SELF]}?action=show&id={$row[id]}"><img src="images/show.png" border=0></a></td>
                </tr>

END;
}
$body .= "</table>";

	$form = array(
			array('label' => '', 'type' => 'hidden', 'name' => 'id', 'value' => $edit[id]),
			array('label' => "progid", 'type' => 'text', 'name' => 'progid', 'value' => $edit[progid], 'size' => 20),
			array('label' => "start", 'type' => 'text', 'name' => 'start', 'value' => $edit[start], 'br' => '<BR />'),
			array('label' => 'stop', 'type' => 'text', 'name' => 'stop', 'value' => $edit[stop]),
			array('label' => 'channelid', 'type' => 'text', 'name' => 'channelid', 'value' => $edit[channelid]),
			array('label' => 'title', 'type' => 'text', 'name' => 'title', 'value' => $edit[title]),
			array('label' => 'descr', 'type' => 'text', 'name' => 'descr', 'value' => $edit[descr]),
			array('label' => 'credit_directors', 'type' => 'text', 'name' => 'credit_directors', 'value' => $edit[credit_directors]),
			array('label' => 'credit_actors', 'type' => 'text', 'name' => 'credit_actors',  'value' => $edit[credit_actors]),
			array('label' => 'credit_producers', 'type' => 'text', 'name' => 'credit_producers',  'value' => $edit[credit_producers]),
			array('label' => 'date', 'type' => 'text', 'name' => 'date',  'value' => $edit[date]),
			array('label' => 'category', 'type' => 'text', 'name' => 'category',  'value' => $edit[category]),
			array('label' => 'length', 'type' => 'text', 'name' => 'length',  'value' => $edit[length]),
			array('label' => 'subtitles', 'type' => 'text', 'name' => 'subtitles',  'value' => $edit[subtitles]),
			array('label' => 'rating_vchip', 'type' => 'text', 'name' => 'rating_vchip',  'value' => $edit[rating_vchip]),
			array('label' => 'rating_advisory', 'type' => 'text', 'name' => 'rating_advisory',  'value' => $edit[rating_advisory]),
			array('label' => 'rating_mpaa', 'type' => 'text', 'name' => 'rating_mpaa',  'value' => $edit[rating_mpaa]),
			array('label' => 'rating_star', 'type' => 'text', 'name' => 'rating_star',  'value' => $edit[rating_star]),
		);
	$smarty->assign("form",1);
	$smarty->assign("formdata",$form);
	$smarty->assign("results",$result);
        $smarty->assign("body",$body);
        $smarty->display($toroid['template']);
}

//Cleanup.
include('includes/bootclose.php');
?>
