﻿# SPOTenantCDNPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **CDNType** | Key | String | Type of Content Delivery Network. Can be 'Private' or 'Public'. | `Private`, `Public` |
| **ExcludeRestrictedSiteClassifications** | Write | StringArray[] | List of site classifications to exclude. | |
| **IncludeFileExtensions** | Write | StringArray[] | List of file extensions to include in the Policy. | |
| **Credential** | Write | PSCredential | Credentials of the Office365 Tenant Admin. | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Name of the Azure Active Directory tenant used for authentication. Format contoso.onmicrosoft.com | |
| **CertificatePassword** | Write | PSCredential | Username can be made up to anything but password will be used for certificatePassword | |
| **CertificatePath** | Write | String | Path to certificate used in service principal usually a PFX file. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

## Description

This resource configures Content Delivery Network policies
for SharePoint Online.

* Not supported in GCC High

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Domain.Read.All

- **Update**

    - Domain.Read.All

#### Application permissions

- **Read**

    - Domain.Read.All

- **Update**

    - Domain.Read.All

### Microsoft SharePoint

To authenticate with the SharePoint API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

#### Application permissions

- **Read**

    - Sites.FullControl.All

- **Update**

    - Sites.FullControl.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        SPOTenantCDNPolicy 'PublicCDNPolicy'
        {
            IncludeFileExtensions                = @('.jpg', '.png')
            CDNType                              = "Public"
            ExcludeRestrictedSiteClassifications = @()
            Credential                           = $Credscredential
        }
        SPOTenantCDNPolicy 'PrivateCDNPolicy'
        {
            IncludeFileExtensions                = @('.gif')
            CDNType                              = "Private"
            ExcludeRestrictedSiteClassifications = @()
            Credential                           = $Credscredential
        }
    }
}
```

