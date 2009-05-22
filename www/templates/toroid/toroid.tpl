<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
        <title>{$title|default:"Toroid - Web Manager"}</title>
        <meta http-equiv="Content-Language" content="English" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <link href="/templates/toroid/toroid.css" rel="stylesheet" type="text/css" />
        <link href="/favicon.ico" rel="Shortcut Icon" />
</head>
<body>

<div id="header">
        <h1><a href="http://www.toroid.tv">Toroid</a></h1>
        <h2>Open Source Middleware</h2>
</div>

<div id="topnav">
	<a href="myprofile.php">My Profile</a> |
	<a href="logout.php">Log out</a>&nbsp;
</div>

<div id="wrap">
	<div id="left">
		<h2>Manage Headend</h2>
		<ul>
			<li>System</li>
				- <a href="manage_system_company.php" class="lefta">Company</a><BR>
				- <a href="manage_system_operators.php" class="lefta">Operators</a><BR>
				- <a href="manage_system_status.php" class="lefta">Status</a><BR>
				- <a href="manage_system_stbprofiles.php" class="lefta">STB Profiles</a><BR>

			<li><a href="manage_channels.php">Channels</a></li>
				- <a href="manage_channels_epg.php" class="lefta">EPG Data</a></li>
			<li><a href="#">Packages, Plans</a></li>
		</ul>		
		<h2>Manage Customers</h2>
		<ul>
			<li><a href="#">Subscribers</a></li>
			<li><a href="#">Messaging</a></li>
		</ul>

		<h2>Billing/OSS</h2>
		<ul>
			<li><a href="#">Billing</a></li>
		</ul>
	</div> 

	<div id="center">
		{$successmessage}
		{$successmenu}
		{$body}
		{if $form eq 1}
		{if $formlock eq 0}
		<form name="form" action="{$smarty.server.PHP_SELF}" method="POST">
		{else}
		{/if}
		<fieldset>
			<legend>{$formname}</legend>
			{section name=formdata loop=$formdata}
			{if $formlock == 1 and $formdata[formdata].name == "Submit"}
			{else}
			<label>{$formdata[formdata].label}<input type="{$formdata[formdata].type}" name="{$formdata[formdata].name}" value="{$formdata[formdata].value}" size="{$formdata[formdata].size}"/></label>{$formdata[formdata].br}
			{/if}
			{/section}
		</fieldset>
		{if $formlock eq 0}
		</form>
		{/if}
		{/if}

	</div>

	<div id="right">
	</div>
	
	<div style="clear:both;"> </div>
	<div id="footer">
		<a href="http://www.toroid.tv">Toroid</a>, Open Source Middleware &copy; Copyright 2007-2008 by <a href="http://www.linopoly.com">Linopoly, LLC</a>, <p>Template by <a href="http://www.free-css-templates.com/">Free CSS Templates</a>
	</div>
</div>
</body>
</html>
