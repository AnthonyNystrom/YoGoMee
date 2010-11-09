<?php
// Make sure SimplePie is included. You may need to change this to match the location of simplepie.inc.
require_once('./php/simplepie.inc');
 
// We'll process this feed with all of the default options.
$feed = new SimplePie('http://blog.7touchgroup.com/feed/');
 
// This makes sure that the content is sent to the browser as text/html and the UTF-8 character set (since we didn't change it).
$feed->handle_content_type();

$feed->init();

$bodyClass = 'home';

include("header.php");
?>
		<img src="img/screenshot.jpg" width="348" height="199" alt="Application screenshot" class="screenshot" />
		<div class="homeContent">
			<h1>mark the spot</h1>
			<p>
				yoGomee is not about finding friends or even making new ones. We leave that to you :) What it is will be revealed soon...
			</p>
			<p>
				<!--<a href="console.php"><img src="img/button-launch-console.gif" width="214" height="60" alt="launch yoGomee" /></a>-->
			</p>
		</div>
		<div class="clear"></div>
	</div>
	<div class="homepagePromo">
		<div class="promoBox1">
			<p class="promoButtons">
				<img src="img/button-supported-phones.gif" width="153" height="36" alt="supported phones" />
			</p>
			<p>
				<img src="img/supported-phones.png" width="251" height="110" alt="iPhone | Android | Blackberry" />
			</p>
		</div>
		<div class="promoBox2">
			<p class="promoButtons">
				<img src="img/button-yogomee-news.gif" width="130" height="36" alt="yoGomee news" />
				&nbsp;&nbsp;
				<a href="http://blog.7touchgroup.com/Posts/" onclick="this.target='_blank'">see all</a>
			</p>
			
			<?php foreach ($feed->get_items(0, 3) as $item): ?>
			<p>
				<small><?php print $item->get_date(); ?></small><br />
				<a href="<?php print $item->get_permalink(); ?>">
				<?php print $item->get_title(); ?></a>					
			</p>
			<?php endforeach; ?>
			
			<!--<p>
				<small>Dec 18th, 2008</small><br />
				yoGomee Snags AT&amp;T, Now Available On Every U.S. Carrier...
				<a href="#">read more</a>
			</p>
			<p>
				<small>Dec 18th, 2008</small><br />
				yoGomee set to unify location-based services across all the networks...
				<a href="#">read more</a>
			</p>-->
		</div>
		<div class="promoBox3">
			<p class="promoButtons">
				<img src="img/button-app-store.gif" width="88" height="36" alt="Application Store" />
			</p>
			<p>
				<img src="img/app-store-iphone.png" width="36" height="36" alt="" class="icon" />
				iPhone App Store<br />
				<a href="http://www.apple.com/iphone/apps-for-iphone/" onclick="this.target='_blank'">visit now</a>
			</p>
			<p>
				<img src="img/app-store-android.png" width="36" height="36" alt="" class="icon" />
				Android Market<br />
				<a href="http://www.android.com/market/" onclick="this.target='_blank'">visit now</a>
			</p>
			<p>
				<img src="img/app-store-blackberry.png" width="36" height="36" alt="" class="icon" />
				BlackBerry App World<br />
				<a href="http://na.blackberry.com/eng/services/appworld/" onclick="this.target='_blank'">visit now</a>
			</p>
		</div>
<?php
include("footer.php");
?>
