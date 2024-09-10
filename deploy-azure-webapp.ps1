param (
    [string]$ResourceGroupName,
    [string]$AppName,
    [string]$Location,
    [string]$AppServicePlanName
)

# Connect to Azure
Connect-AzAccount -ServicePrincipal -TenantId $env:AZURE_TENANT_ID -Credential (New-Object PSCredential($env:AZURE_CLIENT_ID, $(ConvertTo-SecureString $env:AZURE_CLIENT_SECRET -AsPlainText -Force)))

# Create Resource Group if it doesn't exist
if (-not (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location
}

# Create App Service Plan if it doesn't exist
if (-not (Get-AzAppServicePlan -ResourceGroupName $ResourceGroupName -Name $AppServicePlanName -ErrorAction SilentlyContinue)) {
    New-AzAppServicePlan -Name $AppServicePlanName -Location $Location -ResourceGroupName $ResourceGroupName -Tier "Standard"
}

# Create the Web App
if (-not (Get-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppName -ErrorAction SilentlyContinue)) {
    New-AzWebApp -ResourceGroupName $ResourceGroupName -Name $AppName -Location $Location -AppServicePlan $AppServicePlanName
} else {
    Write-Output "Web App $AppName already exists."
}
