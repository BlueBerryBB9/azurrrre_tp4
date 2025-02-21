$RESOURCE_GROUP = "MyResourceGroup4"
$APP_NAME = "flask-app-azure-with-my-id"
$PLAN_NAME = "flask-app-plan"
$LOCATION = "uksouth"
$ZIP_FILE = "flask-app-4.zip"

# -------------------------------
# 2. AUTOMATISATION AVEC TERRAFORM
# -------------------------------

# # Vérification et installation de Terraform
# if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
#     Write-Host "Terraform non trouvé. Installation..."
#     Invoke-WebRequest -Uri "https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_windows_amd64.zip" -OutFile "terraform.zip"
#     Expand-Archive -Path "terraform.zip" -DestinationPath "C:\\Terraform" -Force
#     $env:Path += ";C:\\Terraform"
# }

# Initialiser Terraform
terraform init

# Appliquer la configuration Terraform
terraform apply -auto-approve

Write-Host "Déploiement terminé."

# -------------------------------
# 3. SCALABILITÉ AVEC VIRTUAL MACHINE SCALE SETS
# -------------------------------

# Création du Scale Set avec 2 instances Ubuntu
az vmss create --resource-group $RESOURCE_GROUP --name myScaleSet --image Ubuntu2404 --upgrade-policy-mode automatic --admin-username azureuser --generate-ssh-keys --instance-count 2

# Activer l'auto-scaling
az monitor autoscale create --resource-group $RESOURCE_GROUP --resource myScaleSet --resource-type Microsoft.Compute/virtualMachineScaleSets --name autoscaleRule
az monitor autoscale rule create --resource-group $RESOURCE_GROUP --autoscale-name autoscaleRule --scale out 1 --condition "Percentage CPU > 75 avg 5m"

# -------------------------------
# 4. DÉPLOIEMENT D'UNE AZURE FUNCTION EN PYTHON
# -------------------------------

# # Installer les outils nécessaires
# npm install -g azure-functions-core-tools@4 --unsafe-perm true

# Créer un compte de stockage
az storage account create --name myfuncstorage --location $LOCATION --resource-group $RESOURCE_GROUP --sku Standard_LRS

# Créer une Function App
az functionapp create --resource-group $RESOURCE_GROUP --consumption-plan-location $LOCATION --runtime python --runtime-version 3.9 --functions-version 4 --name myFunctionApp --storage-account myfuncstorage

# Créer une fonction HTTP Trigger
func init myFunctionProj --worker-runtime python
Set-Location myFunctionProj
func new --name HttpExample --template "HTTP trigger" --authlevel "anonymous"

# Tester localement
func start

# Déployer sur Azure
az functionapp deployment source config-zip --resource-group $RESOURCE_GROUP --name myFunctionApp --src function.zip

# -------------------------------
# 5. LIER UNE FONCTION À UN STOCKAGE BLOB
# -------------------------------

# Créer une fonction déclenchée par un fichier Blob
func new --name BlobTrigger --template "Blob trigger" --storage-account myfuncstorage

# Déployer et tester
func start
az functionapp deployment source config-zip --resource-group $RESOURCE_GROUP --name myFunctionApp --src function.zip

# Tester en ajoutant un fichier au blob storage
az storage blob upload --account-name myfuncstorage --container-name samples-workitems --name test.txt --file test.txt
