<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text"/>
<xsl:template match="/">
use toroid;
truncate t_epg_channels;
	<xsl:apply-templates select="tv/channel"/>

truncate t_epg_programs;
	<xsl:apply-templates select="tv/programme"/>

</xsl:template>

<xsl:template match="tv/programme">
INSERT INTO t_epg_programs (id, progid, start, stop, channelid, title, descr, credit_directors, credit_actors, credit_producers, date, category, length, subtitles, rating_vchip, rating_advisory, rating_mpaa, rating_star) VALUES ('', '<xsl:value-of select="episode-num[@system[.='dd_progid']]"/>', '<xsl:value-of select="@start"/>', '<xsl:value-of select="@stop"/>', '<xsl:value-of select="@channel"/>', 
'<xsl:value-of select='translate(title[@lang[.="en"]], "&apos;", "")'/>', '<xsl:value-of select='translate(desc[@lang[.="en"]], "&apos;", "")'/>', 'credit_directors', 'credit_actors','credit_producers', '<xsl:value-of select="date"/>', '<xsl:value-of select="category[@lang[.='en']]"/>', '<xsl:value-of select="length"/>', '<xsl:value-of select="subtitles"/>', '<xsl:value-of select="rating[@system[.='VCHIP']]"/>', 'rating_advisory', 'rating_mpaa', 'rating_star');
</xsl:template>

<xsl:template match="tv/channel">
	INSERT INTO t_epg_channels (id, name) VALUES ('<xsl:value-of select="@id"/>', '<xsl:value-of select="./display-name"/>');
</xsl:template>

</xsl:stylesheet>
