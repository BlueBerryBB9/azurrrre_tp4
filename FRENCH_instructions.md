# Instructions pour le déploiement via l'interface graphique Azure

## 1. Création et déploiement d'un site web Python (Flask) sur Azure App Service

### **1.1 Création du plan d'hébergement**

1. Connectez-vous au portail Azure ([https://portal.azure.com](https://portal.azure.com)).
2. Dans le menu de gauche, cliquez sur **App Services**.
3. Cliquez sur **Créer**.
4. Sélectionnez l'abonnement et créez un nouveau **Groupe de ressources** si nécessaire.
5. Dans **Nom de l'application**, entrez un nom unique.
6. Choisissez **Code** pour le mode de publication.
7. Sélectionnez **Python 3.9** comme runtime.
8. Sélectionnez **Linux** comme système d'exploitation.
9. Dans **Plan d'hébergement**, cliquez sur **Créer un nouveau plan**.
10. Donnez un nom au plan et sélectionnez la tarification **F1 (Gratuit)**.
11. Cliquez sur **Revoir + Créer**, puis sur **Créer**.

### **1.2 Création d'un dépôt Git et ajout des fichiers**

1. Allez sur [GitHub](https://github.com/) et connectez-vous.
2. Cliquez sur **New Repository**.
3. Donnez un nom au dépôt et cochez **Public** ou **Private**.
4. Clonez le dépôt sur votre machine locale.
5. Téléchargez les fichiers `app.py` et `requirements.txt` depuis [ce repository](https://github.com/azure-89/ask-app) et ajoutez-les à votre dépôt Git.
6. Faites un commit et poussez les fichiers vers GitHub.

### **1.3 Déploiement de l'application sur Azure via Git**

1. Retournez sur le portail Azure.
2. Accédez à votre **App Service**.
3. Dans le menu de gauche, cliquez sur **Déploiement > Centre de déploiement**.
4. Sélectionnez **GitHub** comme source de déploiement.
5. Autorisez Azure à accéder à votre compte GitHub et sélectionnez votre dépôt.
6. Sélectionnez la branche à déployer (ex: `main`).
7. Cliquez sur **Valider** et attendez que le déploiement se termine.

### **1.4 Tester l'application**

1. Accédez à **Vue d’ensemble** dans votre App Service.
2. Copiez l'URL du site et ouvrez-la dans un navigateur.
3. Vérifiez que l'application Flask s'affiche correctement.

---

## 2. Automatiser le déploiement avec Terraform

### **2.1 Installer Terraform**

1. Téléchargez Terraform depuis [terraform.io](https://developer.hashicorp.com/terraform/downloads).
2. Installez Terraform sur votre machine.
3. Vérifiez l’installation avec la commande :
   ```sh
   terraform --version
   ```

### **2.2 Utiliser un exemple de configuration Terraform**

1. Clonez le dépôt suivant : [Terraform Provider for Azure](https://github.com/hashicorp/terraform-provider-azurerm).
2. Créez un fichier `main.tf` et configurez l’infrastructure pour correspondre à votre App Service.

### **2.3 Déploiement avec Terraform**

1. Initialisez Terraform :
   ```sh
   terraform init
   ```
2. Appliquez la configuration :
   ```sh
   terraform apply
   ```
3. Vérifiez que l’App Service est bien créé sur Azure.

---

## 3. Scalabilité avec Virtual Machine Scale Sets

### **3.1 Créer un Scale Set**

1. Accédez au portail Azure.
2. Cliquez sur **Machines Virtuelles > Scale Sets**.
3. Cliquez sur **Créer** et remplissez les champs suivants :
   - **Nom** : `MyScaleSet`
   - **Système d'exploitation** : Ubuntu
   - **Nombre d'instances initial** : 2
   - **Type de disque** : SSD
4. Cliquez sur **Créer**.

### **3.2 Activer l’auto-scaling**

1. Accédez à votre Scale Set.
2. Allez dans **Mise à l'échelle automatique**.
3. Ajoutez une règle : **ajouter une VM si l’utilisation CPU dépasse 75%**.
4. Enregistrez les modifications.

### **3.3 Tester la montée en charge**

1. Connectez-vous en SSH à l’une des machines.
2. Installez `stress` :
   ```sh
   sudo apt install stress
   ```
3. Exécutez la commande suivante pour simuler une charge CPU élevée :
   ```sh
   stress --cpu 4 --timeout 300
   ```
4. Vérifiez que de nouvelles instances sont ajoutées automatiquement.

---

## 4. Déploiement d’une Azure Function en Python

### **4.1 Installer les outils nécessaires**

1. Installez **Azure CLI** et **Azure Functions Core Tools**.
2. Connectez-vous à Azure avec :
   ```sh
   az login
   ```

### **4.2 Créer un compte de stockage**

1. Allez sur Azure.
2. Cliquez sur **Stockage > Comptes de stockage**.
3. Cliquez sur **Créer un compte de stockage**.
4. Configurez et validez la création.

### **4.3 Créer une Function App**

1. Allez dans **Azure Functions > Ajouter**.
2. Sélectionnez **Python** comme runtime.
3. Liez votre Function App au compte de stockage précédemment créé.
4. Cliquez sur **Créer**.

### **4.4 Déployer une fonction HTTP Trigger**

1. Clonez l'exemple de code : [Azure Function Example](https://github.com/azure-89/azure-function).
2. Testez la fonction en local :
   ```sh
   func start
   ```
3. Déployez la fonction sur Azure :
   ```sh
   func azure functionapp publish <nom-de-votre-app>
   ```
4. Testez la fonction via son URL publique.

---

## 5. Lier une fonction à un stockage Blob

### **5.1 Créer une fonction déclenchée par un Blob**

1. Clonez l’exemple : [Blob Trigger Function](https://github.com/azure-89/azure-function/tree/blob).
2. Configurez la fonction pour utiliser votre compte de stockage.
3. Déployez la fonction sur Azure.

### **5.2 Tester la fonction**

1. Ajoutez un fichier dans le stockage Blob.
2. Vérifiez que la fonction est déclenchée automatiquement.

---

## 🔗 Ressources supplémentaires

- Documentation Azure Functions : [Microsoft Docs](https://learn.microsoft.com/en-us/azure/azure-functions/)
- Terraform sur Azure : [HashiCorp Docs](https://developer.hashicorp.com/terraform/tutorials/azure-get-started)
- Auto-scaling sur Azure : [Microsoft Docs](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/)
