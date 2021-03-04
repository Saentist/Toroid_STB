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

/* What is this file?
 * Boot strap is the file all toroid php scripts call to
 * initalize classes, functions, and standardized variables.
*/
// Pear requirements
require_once('MDB2.php');
require_once('Pager_Wrapper.php');

require_once('Auth.php');
require_once('smarty/Smarty.class.php');

// Toroid Requirements
require_once('config.php');
require_once('functions.php');

//Initialize MDB2
$db =& MDB2::connect($toroid['db']['dsn']);
if (PEAR::isError($db)) {
    die($db->getMessage());
}
$db->loadModule('Extended');
$db->setFetchMode(MDB2_FETCHMODE_ASSOC);

// Initialize Smarty templating engine
// create object
$smarty = new Smarty;

//
// Initialize PEAR Pager/Pager.php options
//
$pager_options = array(
    'mode'       => 'Sliding',
    'perPage'    => 20,
    'delta'      => 2,
);

//Initialize PEAR auth
$toroid['auth']['options'] = array(	'dsn' => $toroid['db']['dsn'],
					'table' => $toroid['db']['prepend']."operators",
					'usernamecol' => 'username',
					'passwordcol' => 'password',
					'db_options' => array('portability' => MDB2_PORTABILITY_ALL ^ MDB2_PORTABILITY_FIX_CASE)
				);


$auth = new Auth('MDB2', $toroid['auth']['options']);
// $auth->setSessionname("toroid-web");
$auth->start();
?>
