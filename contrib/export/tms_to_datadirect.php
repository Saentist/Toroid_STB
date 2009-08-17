<?
# This script reads the tribune data from the database and returns it formatted as
# a "downloadResponse" like you'd get from TMS DataDirect (actually a SOAP response,
# though we aren't talking SOAP).  This can be used for programs like mythtv's
# mythfilldatabase that normally use the Schedules Direct service, but without the
# network overhead and licensing issues (Schedules Direct is for non-commercial use)

# For schema definistions, see:
# http://docs.tms.tribune.com/tech/tmsdatadirect/schedulesdirect/tvDataDelivery.wsdl
# http://docs.tms.tribune.com/tech/xml/schemas/tmsxtvd.xsd
# http://docs.tms.tribune.com/tech/xml/schemas/tmsxg.xsd

# This script takes the following parameters:
# from:		Starting date/time of the period for which guide data is requested.
#		Default:	00:00:00 (midnight) of the current day
#   to:		Ending date/time of the period for which guide data is requested.
#		Default:	'from' + 24 hours
# days:		Number of days for which guide data is requested. ('to' takes precedence)
#		Default:	(none)
#  mac:		Mac Address of requesting client (weak form of identity, currently unused)
#		Default:	(none)

$lineup = array(
	'id'		=>	'IPTV',
	'name'		=>	'IPTV Lineup',
	'location'	=>	'The Internet',
	'type'		=>	'CableDigital'
);

$max_days_per_request=14;

$MW_DB="toroid";
$MW_DB_HOST="localhost";
$MW_DB_USER="toroid";
$MW_DB_PW="ToRoidPASS";

# if you have tms tables in a separate database:
$TMS_DB=$MW_DB;
$TMS_DB_HOST=$MW_DB_HOST;
$TMS_DB_USER=$MW_DB_USER;
$TMS_DB_PW=$MW_DB_PW;

# stuff $argv into $_GET
if ($argv) {
    foreach ($argv as $k=>$v)
    {
        if ($k==0) continue;
        $it = explode("=",$argv[$k]);
        if (isset($it[1])) $_GET[$it[0]] = $it[1];
    }
}

$DEBUG = (isset($_GET['debug'])) ? 1 : 0;

# force off for production
#$DEBUG=0;

if ($DEBUG) { header('Content-type: text/plain'); }

function debug($msg) {
    global $DEBUG;
    if (! $DEBUG) { return; }
    echo date('H:i:s') . ": $msg\n";
    return;
}

function choke($msg) { debug($msg); die($msg); }

function YN($yn) {
	return ($yn == 'Y') ? "true" : "false";
}

debug("Request from " 
	. (isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : "command line"));

if (isset($_GET['from'])) {
	( $from = strtotime( $_GET['from'] ) ) ||
		choke("Error: called with bad 'from' value.");
	debug("from: " . date('r',$from));
} else {
	$from = strtotime( 'today GMT' );
	debug("default from: " . date('r',$from));
}

if (isset($_GET['to'])) {
	( $to = strtotime( $_GET['to'] ) ) ||
		choke("Error: called with bad 'to' value.");
	debug("to: " . date('r',$to));
} elseif (isset($_GET['days'])) {
	if (is_numeric($_GET['days']) && $_GET['days'] > 0)
		$days = ($_GET['days'] > $max_days_per_request) ? 
			$max_days_per_request : $_GET['days'];
	else
		choke("Error: 'days' must be positive numeric");
	$to = $from + ($days * 24*60*60);
	debug("days: " . $days);
	debug("to: " . date('r',$to));
} else {
	$to = $from + (24 * 60 * 60);
	debug("default to: " . date('r',$to));
}

($from < $to) || choke("Error: 'from' must precede 'to'");
($to - $from < $max_days_per_request*24*60*60) || choke("Error: too large of timeframe requested");

if (isset($_GET['mac'])) {
	if (preg_match('/^[0-9a-f]{12}$/i',$_GET['mac'])) {
	  $mac = $_GET['mac'];
	} else if (preg_match("/^(([\da-f]{1,2})[:.-]){5}([\da-f]{1,2})$/i",$_GET['mac'])) {
	  $s = preg_split("/[:.-]/",$_GET['mac']);
	  $mac = sprintf("%02x%02x%02x%02x%02x%02x",
	    hexdec($s[0]),hexdec($s[1]),hexdec($s[2]),hexdec($s[3]),hexdec($s[4]),hexdec($s[5]));
	} else {
	  $tmpmac = preg_replace('/[:.-]/','',$_GET['mac']);
	  if (preg_match('/^[0-9a-f]{12}$/i',$tmpmac)) {
	    $mac = $tmpmac;
	  }
	}

	if ($mac)
	  debug("mac: $mac");
	else
	  choke("Error: called with invalid 'mac'");
}


debug("connecting to $MW_DB");
($mw_link = mysql_connect($MW_DB_HOST,$MW_DB_USER,$MW_DB_PW,true)) || die('Could not connect: ' . mysql_error());
mysql_select_db($MW_DB, $mw_link);
strlen($response = mysql_error($mw_link)) && choke($response);

if (($TMS_DB == $MW_DB) && ($TMS_DB_HOST == $MW_DB_HOST) && ($TMS_DB_USER == $MW_DB_USER)) {
    $tms_link = $mw_link;
} else {
    debug("connecting to $TMS_DB");
    ($tms_link = mysql_connect($TMS_DB_HOST,$TMS_DB_USER,$TMS_DB_PW,true)) || die('Could not connect: ' . mysql_error());
    mysql_select_db($TMS_DB, $tms_link);
    strlen($response = mysql_error($tms_link)) && choke($response);
}

# caching (not yet implemented):
#	check presence of cached file
#	  if exists, check validity
#	    if valid, return and exit

($X = new XMLWriter()) || choke("Error creating XMLWriter");
$X->openMemory() || choke("XMLWriter::openMemory failed");
$X->setIndent(true);
$X->setIndentString('  ');
$X->startDocument('1.0', 'UTF-8'); 

$X->startElementNS("SOAP-ENV", "Envelope", "http://schemas.xmlsoap.org/soap/envelope/");
$X->writeAttribute("xmlns:xsd", "http://www.w3.org/2001/XMLSchema");
$X->writeAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
$X->writeAttribute("xmlns:SOAP-ENC", "http://schemas.xmlsoap.org/soap/encoding/");
$X->startElement("SOAP-ENV:Body");

$X->startElementNS("tms", "downloadResponse", "urn:TMSWebServices");
$X->writeAttribute("SOAP-ENV:encodingStyle", "http://schemas.xmlsoap.org/soap/encoding/");

$X->startElement("xtvdResponse");
$X->writeAttribute("xsi:type", "tms:xtvdResponse");

$X->startElement("messages");
$X->writeAttribute("xsi:type", "tms:messages");
# Anything you want to tell the user?
$X->writeElement("message","Enjoy the data; use it in good health.");
$X->endElement(); # messages

$X->startElement("xtvd");
$datefmt="Y-m-d\TH:i:s\Z";
$X->writeAttribute("from", gmdate($datefmt, $from));
$X->writeAttribute("to", gmdate($datefmt, $to));
$X->writeAttribute("schemaVersion", "1.3");
$X->writeAttribute("xmlns", "urn:TMSWebServices");
$X->writeAttribute("xsi:schemaLocation",
	"urn:TMSWebServices http://docs.tms.tribune.com/tech/xml/schemas/tmsxtvd.xsd");


# This prints all stations in your tms data, but the <lineups> (below) only includes those
# from your middleware's channel lineups.  Perhaps we should restrict these, too?
$X->startElement("stations");
   debug("reading tms_stations");
   $query = "select tf_station_num as id, "
	. " tf_station_call_sign as callsign, "
	. " tf_station_name as name, "
	. " tf_fcc_channel_num as fccchan, "
	. " tf_station_affil as affiliate "
	. " from tms_stations ";
   debug($query);
   $mysql_result = mysql_query($query, $tms_link);
   strlen($response = mysql_error($tms_link)) && choke($response);
   while ($row = mysql_fetch_array($mysql_result)) {
	$X->startElement("station");
	$X->writeAttribute("id", $row['id']);
	$X->writeElement("callSign", $row['callsign']);
	$X->writeElement("name", $row['name']);
	if ($row['fccchan'])
		$X->writeElement("fccChannelNumber", $row['fccchan']);
	if ($row['affiliate'])
		$X->writeElement("affiliate", $row['affiliate']);
	$X->endElement();
   }
$X->endElement(); # stations


# Customize this to how your middleware stores channel lineups
$X->startElement("lineups");
  $X->startElement("lineup");
  $X->writeAttribute("id", $lineup['id']);
  $X->writeAttribute("name", $lineup['name']);
  $X->writeAttribute("location", $lineup['location']);
  $X->writeAttribute("type", $lineup['type']);

   debug("reading valid_channel_list");
   $query = "select s.tf_station_num as station, c.id as channel "
	. " from tms_stations s, t_channels c "
	. " where s.tf_station_call_sign = c.callsign "
	. " and c.enabled = B'1'";
   debug($query);
   $mysql_result = mysql_query($query, $mw_link);
   strlen($response = mysql_error($mw_link)) && choke($response);
   while ($row = mysql_fetch_array($mysql_result)) {
	$stations[$row['station']] = $row['channel'];
	$X->startElement("map");
	$X->writeAttribute("station", $row['station']);
	$X->writeAttribute("channel", $row['channel']);
	$X->endElement();
   }

  $X->endElement(); # lineup
$X->endElement(); # lineups


$X->startElement("schedules");
   debug("reading tms_schedules");
   # there isn't a regular timestamp in the schedules data, so we over-select
   # the date range needed and filter this out in php to avoid complicated sql foo
   # (you'll optimize this approach if you only request from/to values from exactly midnight)
   $query = "select "
	. " tf_station_num as station, "
	. " tf_database_key as program, "
	. " tf_air_date as date, "
	. " tf_air_time as time, "
	. " tf_duration as duration, "
	. " tf_part_num as number, "
	. " tf_num_of_parts as total, "
	. " tf_cc as cc, "
	. " tf_stereo as stereo, "
	. " tf_subtitled as subtitled, "
	. " tf_tv_rating as tvrating, "
	. " tf_hdtv as hdtv, "
	. " tf_dolby as dolby, "
	. " tf_new as new, "
	. " tf_ei as ei "
	. " from tms_schedules "
	. " where unix_timestamp(str_to_date(tf_air_date, '%Y%m%d')) >= $from ";

   if (($to) % (24*60*60))
	$query .= " and unix_timestamp(str_to_date(tf_air_date, '%Y%m%d')) < " . ($to + 24*60*60);
   else
	$query .= " and unix_timestamp(str_to_date(tf_air_date, '%Y%m%d')) < " . $to;

   debug($query);
   $mysql_result = mysql_query($query, $tms_link);
   strlen($response = mysql_error($tms_link)) && choke($response);
   while ($row = mysql_fetch_array($mysql_result)) {
	if (! $stations[$row['station']]) continue;

	$ts=strtotime( $row['date'] . " " 
		. substr($row['time'],0,2) . ":" . substr($row['time'],2,2) . " GMT");
	if ($from <= $ts && $ts < $to) {
		$programs[$row['program']] = $row['program'];
		$X->startElement("schedule");

		#  Required attributes
		$X->writeAttribute("program", $row['program']);
		$X->writeAttribute("station", $row['station']);
		$X->writeAttribute("time", gmdate($datefmt, $ts));
		$d1 = substr($row['duration'], 0,2);
		$d2 = substr($row['duration'], 2,2);
		$X->writeAttribute("duration", "PT".$d1."H".$d2."M");

		#  Optional attributes
		# skip repeat (how to calculate?)
		if ($row['tvrating'])
		    $X->writeAttribute("tvRating", "TV-". substr($row['tvrating'],2));
		$X->writeAttribute("stereo", YN($row['stereo']));
		$X->writeAttribute("subtitled", YN($row['subtitled']));
		$X->writeAttribute("hdtv", YN($row['hdtv']));
		$X->writeAttribute("closeCaptioned", YN($row['cc']));
		if ($row['dolby'] == 'Dolby' || $row['dolby'] == 'DSS')
		    $X->writeAttribute("dolby", $row['dolby']);
		else if ($row['dolby'] == 'DD' || $row['dolby'] == 'DD5.1')
		    $X->writeAttribute("dolby", "Dolby Digital");
		$X->writeAttribute("new", YN($row['new']));
		if ($row['ei'])
		    $X->writeAttribute("ei", "true");

		if ($row['total'] && $row['number'] >= 1 && $row['total'] > 1 ) {
		    $X->startElement("part");
		    $X->writeAttribute("number", $row['number']);
		    $X->writeAttribute("total", $row['total']);
		    $X->endElement();
		}
		$X->endElement();
	}
   }
$X->endElement(); # schedules

# We'll stuff productionCrew info into $P as we read through program info
($P = new XMLWriter()) || choke("Error creating XMLWriter");
$P->openMemory() || choke("XMLWriter::openMemory failed");
$P->setIndent(true);
$P->setIndentString('  ');

# We'll stuff genre info into $G as we read through program info
($G = new XMLWriter()) || choke("Error creating XMLWriter");
$G->openMemory() || choke("XMLWriter::openMemory failed");
$G->setIndent(true);
$G->setIndentString('  ');

$X->startElement("programs");
   debug("reading tms_programs");
   # given current size of our tms_programs table (< 20MB), this approach is best tradeoff;
   # if PVR, new channel additions or other factors change that, might need to
   # try a join in the above tms_schedules select, or loop through program id's here
   $query = "select * from tms_programs";
   debug($query);
   $mysql_result = mysql_query($query, $tms_link);
   strlen($response = mysql_error($tms_link)) && choke($response);
   while ($row = mysql_fetch_array($mysql_result)) {
	if (isset($programs[$row[0]])) {
	  $X->startElement("program");
	  $X->writeAttribute("id", $row[0]);
	  $X->writeElement("title", $row[1]);

	  # Optional Elements
	  if ($row[156])
	  	$X->writeElement("subtitle", $row[156]);
	  if ($row[159])
	  	$X->writeElement("description", $row[159]);
	  if ($row[144])
	  	$X->writeElement("mpaaRating", $row[144]);
	  if ($row[145])
	  	$X->writeElement("starRating", $row[145]);
	  if ($row[146]) {
	  	$d1 = substr($row[146], 0,2);
	  	$d2 = substr($row[146], 2,2);
	  	$X->writeElement("runTime", "PT".$d1."H".$d2."M");
	  }
	  if ($row[143])
	  	$X->writeElement("year", $row[143]);
	  if ($row[151])
	  	$X->writeElement("showType", $row[151]);
	  if (substr($row[0],0,2) == "SH" || substr($row[0],0,2) == "EP")
	  	$X->writeElement("series", "EP" . substr($row[0],2,8));
	  if ($row[10]||$row[11]||$row[12]||$row[13]||$row[14]||$row[15]) {
		$X->startElement("advisories");
		for ($i=10; $i<=15; $i++)
		    if ($row[$i])
	  		$X->writeElement("advisory", $row[$i]);
		$X->endElement();
	  }
	  if ($row[154])
	  	$X->writeElement("syndicatedEpisodeNumber", $row[154]);
	  if ($row[165])
	  	$X->writeElement("originalAirDate", substr($row[165],0,4) . "-"
			. substr($row[165],4,2) . "-" . substr($row[165],6,2));

	  # productionCrew
	  if ($row[18]) {
		$P->startElement("crew");
		$P->writeAttribute("program", $row[0]);
		for ($i=18; $i<136; $i+=3) {
		    if ($row[$i]) {
			$P->startElement("member");
			$P->writeElement("role", $row[$i]);
			$P->startElement("givenname");
			if($row[$i-2])
			  $P->text($row[$i-2]);
			$P->endElement();
			$P->startElement("surname");
			if ($row[$i-1])
			  $P->text($row[$i-1]);
			$P->endElement();
			$P->endElement();
		    }
		}
		$P->endElement();
	  }

	  # genre
	  if ($row[136]) {
		$G->startElement("programGenre");
		$G->writeAttribute("program", $row[0]);

		$relevance=0;
		for ($i=136; $i<142; $i++) {
		    if ($row[$i]) {
			$G->startElement("genre");
			$G->writeElement("class", $row[$i]);
			$G->writeElement("relevance", $relevance++);
			$G->endElement();
		    }
		}
		$G->endElement();
	  }

	  $X->endElement();
	}
   }
$X->endElement(); # programs


$X->startElement("productionCrew");
$X->writeRaw( $P->outputMemory() );
$X->endElement(); # productionCrew

$X->startElement("genres");
$X->writeRaw( $G->outputMemory() );
$X->endElement(); # genres


$X->endElement(); # xtvd
$X->endElement(); # xtvdResponse

$X->endElement(); # downloadResponse
$X->endElement(); # Body
$X->endElement(); # Envelope

if ($DEBUG)
	debug("XML we've created:\n\n" . $X->outputMemory());
else {
	header('Content-type: text/xml');
	echo $X->outputMemory();
}
?>
