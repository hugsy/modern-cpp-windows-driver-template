param (
    [string]$DriverPath,
    [string]$CertificateStore,
    [string]$CertCommonName
)

$cert = New-SelfSignedCertificate -Type CodeSigningCert -KeyUsage DigitalSignature -HashAlgorithm SHA256 -Subject "$CertCommonName" -CertStoreLocation "cert:\CurrentUser\My"
Set-AuthenticodeSignature -FilePath $DriverPath $cert

$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("My", "CurrentUser")
$store.Open("ReadWrite")
$certs = $store.Certificates | Where-Object { $_.Subject -like "*CN=${CertCommonName}*" }
foreach ($cert in $certs) {
    $store.Remove($cert);
}
$store.Close()
