Import-Module ImportExcel

$cheminFichier1 = "C:\Projet_3\s09_Pharmgreen.xlsx"
$cheminFichier2 = "C:\Projet_3\s14_Pharmgreen.xlsx"

$dataFichier1 = Import-Excel -Path $cheminFichier1
$dataFichier2 = Import-Excel -Path $cheminFichier2

$différences = Compare-Object -ReferenceObject $dataFichier1 -DifferenceObject $dataFichier2 -Property "prénom" -PassThru

if ($différences) {
    $différences | Format-Table -AutoSize | Out-File "C:\Projet_3\liscencier.csv"
} else {
    Write-Host "Aucune différence trouvée entre les fichiers."
}