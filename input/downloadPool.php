<?php 

/*echo 'Wait a few seconds...';
flush(); ob_flush();
echo ' aaand we are done!';
*/function generateRandomString($length = 10) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}

$coord = str_replace('..', '-', $_GET['value']);
$fName = str_replace('-','_',str_replace(':', '-', $coord));
$nchr = explode('_',$fName)[0];

if($_GET['genomicLoc'] == 'region'){

	$rngFile = "/var/www/html/dest/files/tmp/" . $fName . "_" . generateRandomString() . ".vcf.gz";
	exec("/var/www/html/dest/bin/bcftools/bcftools view -Oz -r $coord /var/www/html/dest/files/vcf/dest.ES." . $nchr . ".Aug22_2020.001.50.ann.vcf.gz > $rngFile");	

}else{

	$rngFile = "/var/www/html/dest/files/vcf/dest.ES." . $nchr . ".Aug22_2020.001.50.ann.vcf.gz";
}


//echo "/var/www/html/dest/files/tmp/$rngFile";

header('Pragma: public');
header('Expires: 0');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Cache-Control: private', false); // required for certain browsers 
header('Content-Type: application/zip');

header('Content-Disposition: attachment; filename="'. basename($rngFile) . '";');
header('Content-Transfer-Encoding: binary');
header('Content-Length: ' . filesize($rngFile));

readfile($rngFile);

/*echo ' aaand we are done!';
*/
exit;
?>