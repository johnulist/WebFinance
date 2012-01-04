<?php
/*
 Copyright (C) 2004-2011 NBI SARL, ISVTEC SARL

   This file is part of Webfinance.

   Webfinance is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

    Webfinance is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Webfinance; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/
include("../inc/main.php");

$roles = 'manager,employee';
include("../top.php");
include("nav.php");

if(!isset($_GET['id']) or !is_numeric($_GET['id'])) {
  echo "Invalid direct debit id";
  exit(1);
}

echo '<h1>Invoices debited</h1>';

$res = mysql_query(
  'SELECT invoice_id '.
  'FROM direct_debit_row '.
  "WHERE debit_id = $_GET[id]")
  or die(mysql_error());
?>

<table border="1">
 <tr>
  <th>Company</th>
  <th>Reference</th>
  <th>Date</th>
  <th>Amount excl. VAT</th>
  <th>Amount incl. VAT</th>
 </tr>

<?
$total_ht  = 0;
$total_ttc = 0;
$Invoice = new Facture();
while ($invoice = mysql_fetch_assoc($res)) {
  $info = $Invoice->getInfos($invoice['invoice_id']);
  echo "<tr> <td> $info->nom_client </td>";
  echo "<td> <a href=\"../prospection/edit_facture.php?id_facture=$invoice[invoice_id]\">$info->num_facture</a> </td>";
  echo "<td> $info->nice_date_facture </td>";
  echo "<td> $info->nice_total_ht &euro; </td>";
  echo "<td> $info->nice_total_ttc &euro; </td>";
  echo "</tr>";

  $total_ht  += $info->nice_total_ht;
  $total_ttc += $info->nice_total_ttc;
}
?>

<tr>
  <td></td>
  <td></td>
  <td align="right"> <b>TOTAL</b> </td>
  <td> <?=$total_ht?> &euro; </td>
  <td> <?=$total_ttc?> &euro; </td>
</tr>
</table>

<a href="./">Back</a>

<?
include("../bottom.php");
?>