﻿Configuration ArcGISNotebookServerSettings{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [System.Management.Automation.PSCredential]
        $ServerPrimarySiteAdminCredential,
        
        [Parameter(Mandatory=$false)]
        [System.String]
        $PrimaryServerMachine,

        [Parameter(Mandatory=$false)]
        [System.String]
        $ExternalDNSHostName,

        [Parameter(Mandatory=$false)]
        [System.String]
        $ServerContext
    )


    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ArcGIS -ModuleVersion 4.0.2
    Import-DscResource -Name ArcGIS_NotebookServerSettings

    Node $AllNodes.NodeName
    {
        if($Node.Thumbprint){
            LocalConfigurationManager
            {
                CertificateId = $Node.Thumbprint
            }
        }
        
        if($Node.NodeName -ieq $PrimaryServerMachine){
            ArcGIS_NotebookServerSettings NotebookServerSettings
            {
                ServerHostName      = $Node.NodeName
                WebContextURL       = "https://$ExternalDNSHostName/$($ServerContext)"
                SiteAdministrator   = $ServerPrimarySiteAdminCredential
            }
        }
    }
}
