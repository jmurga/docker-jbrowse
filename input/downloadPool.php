<?php 

function generateRandomString($length = 10) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}


if (!isset($_POST["checkScaffold"]) && isset($_POST["coordinates"])){
    
    $coord = str_replace('..', '-', $_POST['coordinates']);
    $fName = str_replace('-','_',str_replace(':', '-', $coord));
    $nchr = $_POST["nchr"];
    $pop = $_POST["populations"];
    
    $rng = generateRandomString();
    $rngFile = "/var/www/html/dest/files/tmp/" . $fName . "_" . $pop . "_" . $rng . ".vcf";
    $rngSubset = "/var/www/html/dest/files/tmp/subset_" . $rng . ".txt";

    echo "fgrep " . $pop . " /var/www/html/dest/files/vcf/destSamples.txt > " . $rngSubset;
    echo "/var/www/html/dest/bin/bcftools/bcftools view -r $coord -S " . $rngSubset . " /var/www/html/dest/files/vcf/dest." . $nchr . ".Aug22_2020.001.50.ann.vcf.gz > $rngFile";

    exec("fgrep " . $pop . " /var/www/html/dest/files/vcf/destSamples.txt > " . $rngSubset);
    exec("/var/www/html/dest/bin/bcftools/bcftools view -r $coord -S " . $rngSubset . " /var/www/html/dest/files/vcf/dest." . $nchr . ".Aug22_2020.001.50.ann.vcf.gz > $rngFile");
}else{

    $nchr = $_POST["nchr"];
    $pop = $_POST["populations"];
    $fName = str_replace('-','_',str_replace(':', '-', $coord));

    $rng = generateRandomString();
    $rngFile = "/var/www/html/dest/files/tmp/" . $nchr . "_" . $pop . "_" . $rng . ".vcf";
    $rngSubset = "/var/www/html/dest/files/tmp/subset_" . $rng . ".txt";
    
    if($pop != 'ALL'){
        echo "fgrep " . $pop . " /var/www/html/dest/files/vcf/destSamples.txt > " . $rngSubset;
        echo "/var/www/html/dest/bin/bcftools/bcftools view -S " . $rngSubset . " /var/www/html/dest/files/vcf/dest." . $nchr . ".Aug22_2020.001.50.ann.vcf.gz > $rngFile";
        exec("fgrep " . $pop . " /var/www/html/dest/files/vcf/destSamples.txt > " . $rngSubset);
        exec("/var/www/html/dest/bin/bcftools/bcftools view -S " . $rngSubset . " /var/www/html/dest/files/vcf/dest." . $nchr . ".Aug22_2020.001.50.ann.vcf.gz > $rngFile");

    }
    else{
        $rngFile = "/var/www/html/dest/files/vcf/dest." . $nchr . ".Aug22_2020.001.50.ann.vcf.gz";    
    }
    
}


header('Pragma: public');
header('Expires: 0');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Cache-Control: private', false); // required for certain browsers 
header('Content-Type: application/zip');

header('Content-Disposition: attachment; filename="'. basename($rngFile) . '";');
header('Content-Transfer-Encoding: binary');
header('Content-Length: ' . filesize($rngFile));

readfile($rngFile);

exit;
?>