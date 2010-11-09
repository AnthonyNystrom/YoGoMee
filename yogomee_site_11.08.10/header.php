<?php
if(!isset($bodyClass)) {
	$bodyClass = '';
}

if(!isset($pageTitle)) {
	$pageTitle = 'Homepage';
}
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>yoGomee</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	
	<link rel="stylesheet" type="text/css" href="./css/mainstyles.css" />
	<!--[if lte IE 6]>
	<link href="./css/ie6fixes.css" rel="stylesheet" />
	<script type="text/javascript">
	
	//Find all link elements and add an onfocus attribute and value
	function hideFocusBorders(){
		var theahrefs = document.getElementsByTagName("a");
		if (!theahrefs){return;}
		for(var x=0;x!=theahrefs.length;x++){
			theahrefs[x].onfocus = function stopLinkFocus(){this.hideFocus=true;};
		}
	}
	
	window.onLoad = hideFocusBorders();
	</script>
	<![endif]-->
	<!--[if IE 7]>
	<link href="./css/ie7fixes.css" rel="stylesheet" />
	<![endif]-->
</head>
<body<?php echo $bodyClass?' class="'.$bodyClass.'"':''; ?>>
<div class="pageWrapper">
	<div class="pageHeader">
		<a href="index.php" class="siteLogo"><span>yoGomee</span></a>
	</div>
	<div class="pageContent">
		<?php
			if($bodyClass != 'home') {
		?>
		<div class="pageTitle">
			<ul class="mainNav">
				<li><a href="index.php">home</a></li>
				<li><a href="about.php">about</a></li>
				<li><a href="contact.php">contact</a></li>
				<li><a href="privacy.php">privacy</a></li>
			</ul>
			<h1><?php echo $pageTitle ?></h1>
		</div>
		<?php
		}
		?>