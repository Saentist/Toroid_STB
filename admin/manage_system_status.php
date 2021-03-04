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

include('includes/bootstrap.php');
if ($auth->getAuth()) {

// Logged in
$body .= <<<END
<h2>System Status</h2>
<h3>Toroid Status</h3>
<p>
x subscribers
</p>

<h3>phpSysInfo Status</h3>
<iframe src="sysinfo/index.php" width=520 height=700></iframe>

END;

//Render the the system status module
        $smarty->assign("title","Toroid - System Status");
        $smarty->assign("username",$_SESSION['_authdata']['username']);
        $smarty->assign("body",$body);
        $smarty->display($toroid['template']);
}

//Cleanup.
?>
