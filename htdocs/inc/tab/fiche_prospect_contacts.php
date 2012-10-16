<?php
/*
 Copyright (C) 2004-2006 NBI SARL, ISVTEC SARL

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
?>
<?php
//
// This file is part of « Webfinance »
//
// Copyright (c) 2004-2006 NBI SARL
// Author : Nicolas Bouthors <nbouthors@nbi.fr>
//
// You can use and redistribute this file under the term of the GNU GPL v2.0
//
# $Id: fiche_prospect_contacts.php 556 2007-08-02 08:29:36Z gassla $

global $Client, $User;


?>
  <table border="0" width="100%"><tr valign="top"><td>
  <b><?= _('Address :') ?></b><br/>
  <input type="text" name="addr1" value="<?= preg_replace('/"/', '\\"', $Client->addr1) ?>" style="color: #666; width: 200px" /><br/>
  <input type="text" name="addr2" value="<?= preg_replace('/"/', '\\"', $Client->addr2) ?>" style="color: #666; width: 200px" /><br/>
  <input type="text" name="addr3" value="<?= preg_replace('/"/', '\\"', $Client->addr3) ?>" style="color: #666; width: 200px" /><br/>
  <input type="text" name="cp" value="<?= preg_replace('/"/', '\\"', $Client->cp) ?>" style="text-align: center; color: #666; width: 48px" /><input type="text" name="ville" value="<?= $Client->ville ?>" style="color: #666; width: 148px" /><br/>
  <input type="text" name="pays" value="<?= preg_replace('/"/', '\\"', $Client->pays) ?>" style="color: #666; width: 80px; text-align: center;" /><br/>
  <b><?= _('Login and password:') ?></b><br/>
  <input type="text" name="login" value="<?= $Client->login ?>" class="person" /><br/>
  <input type="text" name="password" value="<?= $Client->password ?>" class="keyring" />
<?php
   if(!empty($Client->email)){
     printf('<a href="javascript:confirmSendInfo(%d,\'%s\');"><img src="../imgs/icons/mail-send.png" title="%s" /></a>',$Client->id,_('Send info to client?'),_('Send informations'));
   }
  ?>
<br/>
  <b><?= _('Phone and URL:') ?></b><br/>
  <input type="text" name="tel" value="<?= addslashes($Client->tel) ?>" class="tel" /><input type="text" name="fax" value="<?= $Client->fax ?>" class="fax" /><br/>
  <input type="text" name="web" value="<?= addslashes($Client->web) ?>" class="web" /><br/>
<?php

  $mails = explode(',', $Client->email);

  foreach($mails as $mail)
   echo '<input type="text" name="email[]" value="'.$mail.'" class="email" /><br/>';

?>
  <input type="text" name="email[]" class="email" /><br/>
<br/>
  <b><?= _('RIB:') ?></b><br/>
<table border="0">
	<tr><td><?= _('Holder name:') ?></td><td><input type="text" size="10" maxsize="24" name="rib_titulaire" value="<?= addslashes($Client->rib_titulaire) ?>" style="color: #666;" /></td></tr>
    <tr><td><?= _('Bank name:') ?></td><td><input type="text" size="10" maxsize="24" name="rib_banque" value="<?= addslashes($Client->rib_banque) ?>" style="color: #666;" /></td></tr>
    <tr><td><?= _('Bank code:') ?></td><td><input type="text" size="5" maxlength="5" name="rib_code_banque" value="<?= addslashes($Client->rib_code_banque) ?>" style="color: #666;" /></td></tr>
    <tr><td><?= _('Bank agency:') ?></td><td><input type="text" size="5" maxlength="5" name="rib_code_guichet" value="<?= addslashes($Client->rib_code_guichet) ?>" style="color: #666;" /></td></tr>
    <tr><td><?= _('Bank account:') ?></td><td><input type="text" size="11" maxlength="11" name="rib_code_compte" value="<?= addslashes($Client->rib_code_compte) ?>" style="color: #666;" /></td></tr>
    <tr><td><?= _('Bank key:') ?></td><td><input type="text" size="2" maxlength="2" name="rib_code_cle" value="<?= addslashes($Client->rib_code_cle) ?>" style="color: #666;" />
</table>
<br/>
  <?= $Client->link_societe ?>
  </td><td width="100%">

  <b><?= _('Contacts :') ?></b><br/>
  <?include "contact_entreprise.php" ?>
  <div style="text-align: center;">
<?php
    if($User->hasRole("manager",$_SESSION['id_user']) || $User->hasRole("employee",$_SESSION['id_user']) ){
      printf("<a href=\"#\" onclick=\"inpagePopup(event, this, 240, 220, 'edit_contact.php?id=_new&id_client=%d');\">%s</a>" , $Client->id , _('Add a new contact'));
    }
?>
  </div>
  </td>

  </table>