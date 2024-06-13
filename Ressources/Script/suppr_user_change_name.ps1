clear
$FilePath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$cheminFichier = "$FilePath\difference.CSV"

$Users = Import-Csv -Path $cheminFichier -Delimiter "," -Header "Prenom", "Nom" | Select-Object -Skip 1

#$Users | Format-Table -AutoSize

$i = 0
$j = 1
$delimiter = (Get-Content $cheminFichier).Length - 1
#Write-Host $delimiter
foreach($User in $Users)
{
   
    $User1 = $Users.Nom
    $User2 = $users.Nom
    while($i -lt $delimiter)
    {
        while($j -lt $delimiter)
        {
            #write-host $User1[$i]
            #write-host $User2[$j]
            #write-host "------------------"
            if($User1[$i] -like "*$($User2[$j])*") 
            {
                write-host "l'utilisateur "$User2[$j]" existe deja"
                write-host "supresion de "$User2[$j]""
            }
            $j++ 
        }
        $i++
        $j = $i + 1
    }
}
