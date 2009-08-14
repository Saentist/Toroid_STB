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
$section = "EPG Data";
$smarty->assign("title","Toroid - $section");


$body .= <<<END
                <h2>${section} Menu</h2>
		EPG data is only viewable, and cannot be edited.  This data is retrieved from your XMLTV provider.<BR/><BR/>
		<a href="show_epg_channels.php">EPG Channels</a><BR/>
		<a href="show_epg_programs.php">EPG Programs</a><BR/>
END;

	$smarty->assign("results",$result);
        $smarty->assign("body",$body);
        $smarty->display($toroid['template']);
}

//Cleanup.
include('includes/bootclose.php');
?>
