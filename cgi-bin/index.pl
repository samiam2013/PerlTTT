#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;


#headers end with \n\n
print "Content-type: text/html";
print "\n\n";

print "
<html>
	<head>
		<h3>Perl Generated index page</h3>
	</head>
	<body>
		<p>You can follow instructions here to make this page run
		on a centos 7/8 install [probably most redhat distros] with
		Apache [httpd]</p>

		<a href=\"https://www.server-world.info/en/note?os=CentOS_7&p=httpd&f=2\">Link to Server World [.info] page]</a>
		<br />

		<p>In case that link is broken just search the web for how to
		get Perl CGI + Apache installed on CentOS. Additionally, you'll
		need to  point the default [localhost or domain] host in Apache
		at the github repository files.</p>
		<p>You may also need to check with <pre>sestatus</pre> to see
		if you need to modify SELinux permissions for httpd with this fix
		if SELinux is enabled:
		<pre>semanage fcontext -a -t httpd_sys_script_exec_t \"/var/www/html/cgi-test(/.*)?\"</pre>
		and update the rules with this
		<pre>restorecon -R -v /var/www/html/cgi-test</pre>
		replacing <pre>cgi-test</pre> with the location of the downloaded
		github repo <pre>PerlTTT/cgi-bin</pre>
		</p>

		<p>this link is the reason for this page, I'll be loading a
		React.JS interface to play tic-tac-toe with (Ideally using a
		mini-max algorithm for the autonomous player, using this api
		with JSON inputs/outputs </p>
		<a href=\"/cgi-bin/tic-tac-toe-api.pl\">Tic-Tac-Toe API</a>

	</body>
</html>";
