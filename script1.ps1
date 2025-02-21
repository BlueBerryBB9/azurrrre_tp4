# -------------------------------
# 1. DÉPLOIEMENT FLASK SUR AZURE
# -------------------------------

# Définition des variables
$RESOURCE_GROUP = "MyResourceGroup4"
$APP_NAME = "flask-app-azure-with-my-id"
$PLAN_NAME = "flask-app-plan"
$LOCATION = "uksouth"
$ZIP_FILE = "flask-app-4.zip"

# Vérifier si le groupe de ressources existe déjà
$RG_EXIST = az group show --name $RESOURCE_GROUP --query "name" --output tsv 2>$null
if (-not $RG_EXIST) {
    az group create --name $RESOURCE_GROUP --location $LOCATION
}
else {
    Write-Host "Le groupe de ressources '$RESOURCE_GROUP' existe déjà."
}

# Vérifier si le plan d'hébergement existe déjà
$PLAN_EXIST = az appservice plan show --name $PLAN_NAME --resource-group $RESOURCE_GROUP --query "name" --output tsv 2>$null
if (-not $PLAN_EXIST) {
    az appservice plan create --name $PLAN_NAME --resource-group $RESOURCE_GROUP --sku F1 --is-linux
}
else {
    Write-Host "Le plan d'hébergement '$PLAN_NAME' existe déjà."
}

# Vérifier si l'application web existe déjà
$APP_EXIST = az webapp show --name $APP_NAME --resource-group $RESOURCE_GROUP --query "name" --output tsv 2>$null
if (-not $APP_EXIST) {
    az webapp create --resource-group $RESOURCE_GROUP --plan $PLAN_NAME --name $APP_NAME --runtime "PYTHON:3.9"
}
else {
    Write-Host "L'application web '$APP_NAME' existe déjà."
    Start-Sleep -Seconds 10
}


# Déploiement depuis le fichier ZIP
az webapp deployment source config-zip --resource-group $RESOURCE_GROUP `
    --name $APP_NAME --src $ZIP_FILE

# Récupération de l'URL de l'application
$APP_URL = az webapp show --resource-group $RESOURCE_GROUP --name $APP_NAME --query "defaultHostName" --output tsv
Write-Host "L'application est disponible à l'adresse : https://$APP_URL"
