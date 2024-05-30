param(
    [string]$ResourceGroup,
    [string]$StorageAccountName,
    [string]$IndexFileName,
    [string]$NotFoundFileName
)

Set-AzCurrentStorageAccount -ResourceGroupName $ResourceGroup -Name $StorageAccountName
Enable-AzStorageStaticWebsite -IndexDocument $IndexFileName -ErrorDocument404Path $NotFoundFileName