provider "azurerm" {
  features {}
  subscription_id = "d8197416-3f61-4be4-b4ec-512290a92dfc"
}

resource "azurerm_resource_group" "flask_rg" {
  name     = "MyResourceGroup4"
  location = "uksouth"
}

resource "azurerm_service_plan" "flask_plan" {
  name                = "flask-app-plan"
  location            = azurerm_resource_group.flask_rg.location
  resource_group_name = azurerm_resource_group.flask_rg.name
  sku_name            = "F1"    # Free plan
  os_type             = "Linux" # For Flask app on Linux
}

resource "azurerm_linux_web_app" "flask_app" {
  name                = "flask-app-azure-with-my-id"
  resource_group_name = azurerm_resource_group.flask_rg.name
  location            = azurerm_resource_group.flask_rg.location
  service_plan_id     = azurerm_service_plan.flask_plan.id

  app_settings = {
    "FLASK_ENV" = "production"
  }

  site_config {
    always_on        = false
    app_command_line = "gunicorn -b 0.0.0.0:8000 app:app"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "null_resource" "deploy_flask_zip" {

  triggers = {
    always_run = timestamp() # This ensures it changes every time you run apply
  }

  provisioner "local-exec" {
    command = "az webapp deploy --resource-group MyResourceGroup4 --name flask-app-azure-with-my-id --src-path ./flask-app-4.zip --type zip"
  }

  depends_on = [azurerm_linux_web_app.flask_app]
}
