<?php
include("../../../inc/main.php");
$title = _("Paybox");

extract($_GET);

//"PBX_RETOUR" => "montant:M;ref:R;auto:A;trans:T;pbxtype:P;card:C;soletrans:S;error:E",
//http://webfinance.dev.jexiste.org/payment/paybox/ok.php?montant=14472&ref=1041153308810&auto=XXXXXX&trans=605964387&pbxtype=CARTE&card=CB&soletrans=608599999&error=00000

if(isset($ref,$auto) AND !empty($ref) AND !empty($auto)){
  $res = mysql_query("UPDATE webfinance_paybox SET ".
		     "state='ok' , ".
		     "autorisation='$auto' , ".
		     "transaction_id='$trans' , ".
		     "amount='$montant/100' ,".
		     "payment_type='$pbxtype' ,".
		     "card_type='$card' ,".
		     "transaction_sole_id='$soletrans' ,".
		     "error_code='$error' , ".
		     "date=NOW() ".
		     "WHERE reference='$ref'") or wf_mysqldie();

  if($res){
    $Invoice = new Facture();
    $res = mysql_query("SELECT id_invoice FROM webfinance_paybox WHERE reference='$ref'") or wf_mysqldie();
    list($id_invoice) = mysql_fetch_array($res);
    if($Invoice->exists($id_invoice)){
      mysql_query("UPDATE webfinance_invoices SET is_paye=1, date_paiement=NOW() WHERE id_facture=$id_invoice ") or wf_mysqldie();
      $invoice = $Invoice->getInfos($id_invoice);
      if($invoice->is_paye){
	$Invoice->updateTransaction($invoice->id_invoice,"real");
      }
    }
  }
 }else{
  require("/usr/share/php/libphp-phpmailer/class.phpmailer.php");

  $result = mysql_query("SELECT value FROM webfinance_pref WHERE type_pref='societe' AND owner=-1") or wf_mysqldie();
  list($value) = mysql_fetch_array($result);
  mysql_free_result($result);

  $societe = unserialize(base64_decode($value));

  $mail = new PHPMailer();
  $mail->From = $societe->email;
  $mail->CharSet = "UTF-8";
  $mail->FromName = "[WEBFINANCE]";
  $mail->Subject= "[ALERT] CB transaction, REF or AUTORISATION not found";
  $mail->AddAddress($societe->email, $societe->raison_sociale );
  $mail->Body = "CB transaction, REF or AUTORISATION not found";
  $mail->Send();

 }
exit;


?>