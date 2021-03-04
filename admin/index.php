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
// Logged in, show them the system status module
header("Location: manage_system_status.php");
}
?>
