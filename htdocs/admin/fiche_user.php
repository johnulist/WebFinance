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
$roles = 'admin';
include("../top.php");
include("nav.php");

if (!is_numeric($_GET['id'])) {
  header("Location: index.php");
}

$User = new User();
$user = $User->getInfos($_GET['id']);
if ($_GET['id'] == -1) { $user->id_user = -1; }

?>

<h2>Modification d'un utilisateur</h2><br/>

<script type="text/javascript">
function checkForm(f) {
  f.submit();
}
</script>

<?= $_SESSION['message']; $_SESSION['message']=""; ?>

<form name="userdata" action="save_user.php" method="post">
<input type="hidden" name="id_user" value="<?= $user->id_user ?>" />
<table border="0" cellspacing="0" cellpadding="3">
<tr>
  <td>Prénom</td><td><input type="text" size="20" name="first_name" value="<?=$user->first_name ?>" /></td>
  <td>Nom</td><td><input type="text" size="20" name="last_name" value="<?=$user->last_name ?>" /></td>
</tr>
<tr>
  <td>Login</td><td><input type="text" size="20" name="login" value="<?=$user->login ?>" /></td>
  <td>Email</td><td><input type="text" size="50" name="email" value="<?=$user->email ?>" /></td>
</tr>
<tr>
  <td><?=_('Password')?></td><td><input type="password" size="20" name="password"/></td>
  <td>
<?php
    if($user->id_user>0){
      echo _("let it empty if you don't want to change");
    }else{
      echo _("autogenerate if empty");
    }
?>
  </td>
</tr>
<tr>
  <td valign="top" colspan="3">
    <input type="checkbox" name="disabled" <?= ($user->disabled)?"checked":"" ?> /> Compte désactivé<br/>
  </td>
  <td>
    Créé le <?=$user->nice_creation_date?><br/>
    Modifié le <?=$user->nice_modification_date?>
  </td>
</tr>
 <tr>
 <td colspan="4">
  <table>
   <tr>
    <td>Roles:</td>
<?
   $result=mysql_query("SELECT id_role, name FROM webfinance_roles") or wf_mysqldie();
   while($role=mysql_fetch_assoc($result)){
    printf("<td><input type='checkbox' name='role[]' %s value='%s' >%s</td>",($User->hasRole($role['name'] , $user->id_user )>0)?"checked":"",$role['name'],$role['name'] );
   }
?>
   </tr>
  </table>
 </td>
</tr>
<tr>
  <td colspan="4" style="text-align: center;">
  <?php
  $save_off = '/imgs/boutons/'.urlencode(base64_encode(_('Save').":off:".$User->prefs->theme)).".png";
  $save_on = '/imgs/boutons/'.urlencode(base64_encode(_('Save').":on:".$User->prefs->theme)).".png";

  $cancel_off = '/imgs/boutons/'.urlencode(base64_encode(_('Cancel').":off:".$User->prefs->theme)).".png";
  $cancel_on = '/imgs/boutons/'.urlencode(base64_encode(_('Cancel').":on:".$User->prefs->theme)).".png";
  ?>
    <img onclick="checkForm(document.forms['userdata']);" src="<?= $save_off ?>" onmouseover="this.src='<?= $save_on ?>';" onmouseout="this.src='<?= $save_off ?>';" />
    <img onclick="window.location='index.php'" src="<?= $cancel_off ?>" onmouseover="this.src='<?= $cancel_on ?>';" onmouseout="this.src='<?= $cancel_off ?>';" />
  </td>
</tr>
</table>
</form>


<?php
$Revision = '$Revision$';
include("../bottom.php");
?>
