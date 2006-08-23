<?php
include("../../inc/main.php");
$title = _("Paybox");
$roles="manager,accounting,employee,client";
include("../../top.php");

if(isset($_GET['ref']) ){
  //"PBX_RETOUR" => "amount:M;ref:R;auto:A;trans:T;pbxtype:P;card:C;soletrans:S;error:E",

  extract($_GET);

  if($error>=100 AND $error<200)
    printf("<span class='text'>%s</span>", _("Paiement refus� par le centre d'autorisation"));
  else if(isset($error)){

    $_SESSION['error']=1;

    switch($error){
    case 0:
      printf("<span class='text'>%s</span>", _("The transaction accepted")); //error in PBX_EFFECTUE or PAYBOX :)
      $_SESSION['message']=_("The transaction accepted");
      break;
    case 3:
      printf("<span class='text'>%s</span>", _("Erreur Paybox"));
      $_SESSION['message']=_("Erreur Paybox");
      break;
    case 4:
      printf("<span class='text'>%s</span>", _("Num�ro de porteur ou cryptogramme visuel invalide"));
      $_SESSION['message']=_("Num�ro de porteur ou cryptogramme visuel invalide");
      break;
    case 6:
      printf("<span class='text'>%s</span>", _("Acc�s refus� ou site/rang/identifiant incorrect"));
      $_SESSION['message']=_("Acc�s refus� ou site/rang/identifiant incorrect");
      break;
    case 8:
      printf("<span class='text'>%s</span>", _("date de fin de validit� incorrect"));
      $_SESSION['message']=_("date de fin de validit� incorrect");
      break;
    case 11:
      printf("<span class='text'>%s</span>", _("Montant incorrect"));
      $_SESSION['message']=_("Montant incorrect");
      break;
    case 15:
      printf("<span class='text'>%s</span>", _("Erreur Paybox"));
      $_SESSION['message']=_("Erreur Paybox");
      break;
    case 16:
      printf("<span class='text'>%s</span>", _("Abonn�e d�j� existant..."));
      $_SESSION['message']=_("Abonn�e d�j� existant...");
      break;
    case 21:
      printf("<span class='text'>%s</span>", _("Bin de carte non autoris�e"));
      $_SESSION['message']=_("Bin de carte non autoris�e");
      break;
    }
  }else{
      printf("<span class='text'>%s</span>", _("PAYBOX INPUT ERROR") ." ". $error);
      $_SESSION['message']=_("PAYBOX INPUT ERROR") ." ". $error;
  }
  mysql_query("UPDATE webfinance_paybox SET ".
	      "state='deny', ".
	      "payment_type='$pbxtype' , ".
	      "transaction_sole_id='$soletrans', ".
	      "error_code='$error'  ".
	      "WHERE reference='$ref'") or wf_mysqldie();
 }else{
?>
  <span class="text">
    <? echo _("Wrong arguments"); ?>
  </span>
<?
 }
?>
<br/>
<a href="../../client/"><?=_('Back')?></a>

<?php
$Revision = '$Revision$';
include("../../bottom.php");
?>