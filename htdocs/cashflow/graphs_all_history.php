<?php
// $Id$

require("../inc/main.php");

$title = _("Financial graphics");
$roles = 'manager,accounting';
require("../top.php");
require("nav.php");

?>

<img src="../graphs/cashflow.php?account=&end_date=&width=800&height=400&movingaverage=0" />

<img src="plots.php?account=&width=800&height=400"/>

<img src="./plots_all_history.php?type=category&sign=positive&plot=piecharts"/>

<img src="plots_all_history.php?type=category&sign=negative&plot=piecharts"/>

<img src="plots_all_history.php?type=category&sign=positive&plot=bars"/>

<img src="plots_all_history.php?type=category&sign=negative&plot=bars"/>

<?
$Revision = '$Revision$';
require("../bottom.php");
?>
