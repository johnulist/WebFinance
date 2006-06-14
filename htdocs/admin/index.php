<?php
//
// This file is part of « Webfinance »
//
// Copyright (c) 2004-2006 NBI SARL
// Author : Nicolas Bouthors <nbouthors@nbi.fr>
//
// You can use and redistribute this file under the term of the GNU GPL v2.0
//
?>
<?php
// $Id$

include("../inc/main.php");
$title = _("Administration");
$roles = "admin,manager,employee";
include("../top.php");
include("nav.php");
?>
<script type="text/javascript">
function confirmDeleteUser(id) {
  if (confirm('Voulez-vous vraiment supprimer cet utilisateur ?')) {
    window.location = 'save_user.php?action=delete&id='+id;
  }
}
</script>

<?= $_SESSION['message']; $_SESSION['message']=""; ?>

<h2><?=_('BackOffice users')?></h2>
<?
  $order = "DESC";
  $link = "&d=1";
  if(isset($_GET['d']) AND $_GET['d']==1){
    $order = "";
    $link = "";
  }

?>


<table border="0" cellspacing="0" cellpadding="5" class="framed">
<tr align=center class="row_header">
  <td><a href="?sort=login<?=$link?>">Login</a></td>
  <td><a href="?sort=name<?=$link?>">Nom</a></td>
  <td><a href="?sort=email<?=$link?>">Mail</a></td>
  <td><a href="?sort=last_login<?=$link?>">Last login</a></td>
  <td>Actions</td>
</tr>
<?php
  $critere = " last_login $order ";
  if(isset($_GET['sort'])){
    switch ($_GET['sort']) {
    case "login" :
       $critere = " login $order ";
       break;
    case "name" :
      $critere = " first_name $order, last_name $order ";
      break;
    case "email" :
      $critere = " email $order ";
      break;
    case "last_login" :
      $critere = " last_login $order";
      break;
    }
  }

$result = mysql_query("SELECT first_name,last_name,id_user,email,login, role, date_format(last_login,'%d/%m/%Y') as nice_last_login
                       FROM webfinance_users ORDER by ".$critere) or wf_mysqldie();
$count=1;
while ($user = mysql_fetch_object($result)) {
  $rowclass = ($count%2)==0?"odd":"even";
  if($user->role!='client'){
  print <<<EOF
<tr class="row_$rowclass">
  <td style="text-align: center">$user->login</td>
  <td>$user->first_name $user->last_name</td>
  <td><a href="mailto:$user->email">$user->email</a></td>
  <td>$user->nice_last_login</td>
  <td>
    <a href="javascript:confirmDeleteUser($user->id_user);"><img src="/imgs/icons/delete.png" alt="<?= _('Delete')?>" /></a>
    <a href="#" onclick="inpagePopup(event, this, 280, 260, 'edit_user.php?id=$user->id_user$link');" ><img src="/imgs/icons/edit.png" alt="Modifier" /></a>
  </td>
</tr>
EOF;
  $count++;

  }
}
mysql_free_result($result);

?>
</table><br/>
<a href="#" onclick="inpagePopup(event, this, 280, 260, 'edit_user.php?id=-1<?=$link?>');"><?= _('Add a user') ?></a>

<?php

$Revision = '$Revision$';
include("../bottom.php");

?>
