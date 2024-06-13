Import-Module ImportExcel

$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$cheminFichier1 = "$FilePath\s09_Pharmgreen.CSV"
$cheminFichier2 = "$FilePath\s14_Pharmgreen.CSV"

$dataFichier1 = Import-Csv -Path $cheminFichier1
$dataFichier2 = Import-Csv -Path $cheminFichier2

$différences = Compare-Object -ReferenceObject $dataFichier1 -DifferenceObject $dataFichier2 -Property "prénom","nom","Date de naissance" -PassThru

if ($différences) {
    $différences | Export-Csv -Path "$FilePath\difference.csv" -NoTypeInformation
} else {
    Write-Host "Aucune différence trouvée entre les fichiers."
}


