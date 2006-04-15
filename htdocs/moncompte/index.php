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

$User = new User();

if ($GLOBALS['_SERVER']['REQUEST_METHOD'] == "POST") {
  extract($_POST);
  if ($action == "changepass") {
    if ($new_pass1 != $new_pass2) {
      $_SESSION['message'] = _("The passwords don't match");
      header("Location: index.php");
      die();
    }
    $User->changePass($_SESSION['id_user'], $old_password, $new_pass1);
  } else if ($action == "userprefs") {
    $Prefs = new stdClass();
    foreach ($_POST as $n=>$v) {
      if (preg_match("/^pref_(.*)$/", $n, $matches)) {
        $prefname = $matches[1];
        $Prefs->$prefname = $v;
      }
    }
    $data = base64_encode(serialize($Prefs));
    $User->setPrefs($Prefs);
    header("Location: index.php");
    die();
  }
}


$user = $User->getinfos($_SESSION['id_user']);

include("../top.php");

?>

<script type="text/javascript">
function checkForm(f) {
  f.submit();
}
</script>
<h2>Mon mot de passe</h2>

<div style="background: #ffcece;"><?= $_SESSION['message']; $_SESSION['message'] = ""; ?></div>

<form id="main_form" name="change_pass" action="index.php" method="post">
<input type="hidden" name="action" value="changepass" />
<table border="0" cellspacing="7" cellpadding="0">
<tr>
  <td>Ancien mot de passe</td>
  <td><input name="old_password" type="password" class="border" /></td>
</tr>
<tr>
  <td>Nouveau mot de passe</td>
  <td><input name="new_pass1" type="password" class="border" /></td>
</tr>
<tr>
  <td>Répéter</td>
  <td><input name="new_pass2" type="password" class="border" /></td>
</tr>
<tr>
  <td colspan="2" style="text-align: center;">
    <input type="submit" value="<?= _("Save") ?>" />
  </td>
</tr>
</table>
</form>

<h2>Options personnelles</h2>

<form id="main_form" name="user_prefs" action="index.php" method="post">
<input type="hidden" name="action" value="userprefs" />
<table border="0" cellspacing="0" cellpadding="5">
<tr>
  <td><?= _("Language") ?></td>
  <td>
    <select name="pref_lang">
    <?php
      $choices = array("Français" => "fr_FR",
                       "English" => "en_US");
      foreach ($choices as $n=>$v) {
        printf('<option value="%s"%s>%s</option>', $v, ($v==$User->prefs->lang)?" selected":"", $n );
      }
    ?>
    </select>
  </td>
  <td>Thème graphique</td>
  <td>
    <select name="pref_theme">
    <?php
    $themes = glob("../css/main*.css");
    foreach ($themes as $theme) {
      $theme = basename($theme);
      $theme = preg_replace("/\.css$/", "", $theme);
      printf('<option value="%s"%s>%s</option>',
             $theme, ($theme==$User->prefs->theme)?" selected":"", $theme );
    }
    ?>
    </select>
  </td>
</tr>
<tr>
  <td><?= _('Sort companies by') ?></td>
  <td><select name="pref_tri_entreprise">
  <?php
  foreach (array('ca_total_ht' => _('Total Income'),
                 'ca_total_ht_year' => _('Year Income'),
                 'du' => _('Up to date / has unpaid'),
                 'total_du_ht' => _('Owed'),
                 'nom' => _('Company name')) as $v=>$n) {
    printf('<option value="%s"%s>%s</option>', $v, ($v==$User->prefs->tri_entreprise)?" selected":"", $n);
  }
  ?>
  </select></td>
</tr>
<tr>
  <td>Onglet par défaut dans la fiche entreprise</td>
  <td><select name="pref_default_onglet_fiche_contact">
  <?php
  foreach (array(
                  'contacts' => _('Contact & Adresses'),
                  'facturation' => _('Billing'), 
                  'log' => _('Client log'),
                  'other' => _('Miscelaneous'),
                  'graph' => _('Graphics')
                 ) as $v=>$n) {
    printf('<option value="%s"%s>%s</option>', $v, ($v==$User->prefs->default_onglet_fiche_contact)?" selected":"", $n);
  }
  ?>
  </select></td>
</tr>
<tr>
  <td colspan="2" style="text-align: center;">
    <input type="submit" value="<?= _('Save') ?>" />
  </td>
</tr>
</table>
</form>

<?php
include("../bottom.php");

?>