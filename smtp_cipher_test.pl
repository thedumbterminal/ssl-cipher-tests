#!/usr/bin/env perl
#tests a smtp server for which ssl protocols and ciphers it supports
use strict;
use warnings;
use 5.010;
use Net::SMTP;
use IO::Socket::SSL;
use List::MoreUtils qw(uniq);
$|=1;
my @protocols = ('SSLv2', 'SSLv3', 'TLSv1');
my @ciphers;
if(open(CIPHERS, "openssl ciphers|")){
	my $cipherLine = <CIPHERS>;
	close(CIPHERS);
	chomp $cipherLine;
	@ciphers = uniq(split(/\:/, $cipherLine));
}

die "Usage $0: <host> <port>\n" unless $#ARGV == 1;

my $server = $ARGV[0];
my $port = $ARGV[1];

say "Testing $server:$port";

foreach my $proto (@protocols){
	foreach my $cipher (@ciphers){
		my $result = "ERR";
		print "Connecting using: $proto $cipher ... ";
		my $smtp = Net::SMTP->new($server, Port => $port, Timeout => 10);
		if($smtp){
			eval{
				local $SIG{ALRM} = sub{ die "alarm\n"; };
				alarm 10;
				if($smtp->command('STARTTLS')->response() == Net::Cmd::CMD_OK){
					my %sslArgs = (
						'SSL_version' => $proto,
						'SSL_cipher_list' => $cipher,
						'Timeout' => 10
					);
					my $sslSock = IO::Socket::SSL->new_from_fd($smtp->fileno, %sslArgs);
					$result = "OK" if $sslSock;
				}
				alarm 0;
			};
		}
		say $result;
	}
}
say "...done"