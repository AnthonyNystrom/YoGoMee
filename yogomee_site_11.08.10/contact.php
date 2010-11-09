<?php
// Make sure SimplePie is included. You may need to change this to match the location of simplepie.inc.
require_once('./php/simplepie.inc');
 
// We'll process this feed with all of the default options.
$feed = new SimplePie('http://blog.7touchgroup.com/feed/');
 
// This makes sure that the content is sent to the browser as text/html and the UTF-8 character set (since we didn't change it).
$feed->handle_content_type();

$feed->init();

$pageTitle = 'contact us';

include("header.php");
?>
		
<?php
include("footer.php");
?>
