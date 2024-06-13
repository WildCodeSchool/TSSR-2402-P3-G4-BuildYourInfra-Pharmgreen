Import-Module ImportExcel

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$cheminFichier1 = "$FilePath\s09_Pharmgreen.CSV"
$cheminFichier2 = "$FilePath\s14_Pharmgreen.CSV"
$cheminFichierDiff = "$FilePath\Difference.CSV"



Function ChercheDifference
{
$dataFichier1 = Import-Csv -Path $cheminFichier1
$dataFichier2 = Import-Csv -Path $cheminFichier2


$différences = Compare-Object -ReferenceObject $dataFichier1 -DifferenceObject $dataFichier2 -Property "prénom","Date de naissance" -PassThru

if ($différences) {
    $différences | Export-Csv -Path $cheminFichierDiff -NoTypeInformation
} else {
    Write-Host "Aucune différence trouvée entre les fichiers."
}
}


Write-Host "Début analyse Difference entre $cheminFichier1 et $cheminFichier2 " -ForegroundColor Blue
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
sleep -Seconds 1
ChercheDifference
Write-Host "" 
Write-Host "Fin analyse différence entre $cheminFichier1 et $cheminFichier2 " -ForegroundColor Blue
Write-Host "" 
write-host "Le fichier suivant a été créé $cheminFichierDiff" -ForegroundColor Green
Write-Host "" 
Read-Host "Appuyez sur Entrée pour continuer ... "
Write-Host "" 
