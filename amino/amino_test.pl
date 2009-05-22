#!/usr/bin/perl -w
use IO::Socket::Multicast;
  my $s = IO::Socket::Multicast->new(LocalPort=>1100);
while (1) {
  $s->mcast_if('eth0');
  $s->mcast_ttl(30);
  $s->mcast_loopback(0);
#  $s->mcast_send('hello world!','225.0.0.1:1200');
#  $s->mcast_set('225.0.0.2:1200');
#  $s->mcast_send('hello again!');
open(FILE, "< brian_back.png" ) or die "$!";
	binmode FILE;
#Loop indefinitely
#byte 24 starts filename
# \300 == c0 delimiter?
#              m    o   p   s  .   .   .   .   []          11thbit
$multicast = "\155\157\160\163\000\000\000\000\300\250\005\245";
$multicast .= "\000\000\000\003\0\0\0\001\0\0\0\006";
##File name starts at 24th byte
##file name field is 32 bytes.
$multicast .= "localized_settings";
##while(read (FILE,$data,6144)) {
$s->mcast_send($multicast,'225.10.10.10:4545');
##$multicast .= $data;	
#}
#$s->mcast_send("GIF87a\056\001\045\015\000",'225.0.0.1:1200');
#$s->mcast_send($multicast,'225.0.0.1:1200');

    close FILE;
sleep(2);
}
