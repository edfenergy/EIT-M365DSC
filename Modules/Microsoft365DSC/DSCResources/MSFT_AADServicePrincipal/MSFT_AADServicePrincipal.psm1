function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AddIns,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.String]
        $AppDescription,

        [Parameter()]
        [System.String]
        $AppDisplayName,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.String]
        $ApplicationTemplateId,

        [Parameter()]
        [System.Guid]
        $AppOwnerOrganizationId,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppRoles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CustomSecurityAttributes,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisabledByMicrosoftStatus,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Info,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KeyCredentials,

        [Parameter()]
        [System.String]
        $LoginUrl,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String[]]
        $NotificationEmailAddresses,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Oauth2PermissionScopes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PasswordCredentials,

        [Parameter()]
        [System.String]
        $PreferredSingleSignOnMode,

        [Parameter()]
        [System.String]
        $PreferredTokenSigningKeyThumbprint,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ResourceSpecificApplicationPermissions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SamlSingleSignOnSettings,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [System.Guid]
        $TokenEncryptionKeyId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $VerifiedPublisher,

        [Parameter()]
        [System.String]
        $DeletedDateTime,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        #region resource generator code
        $getValue = Get-MgServicePrincipal -ServicePrincipalId $Id  -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Service Principal with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgServicePrincipal `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript { `
                        $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.ServicePrincipal" `
                    }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Service Principal with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Service Principal with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexAddIns = @()
        foreach ($currentaddIns in $getValue.AdditionalProperties.addIns)
        {
            $myaddIns = @{}
            $myaddIns.Add('Id', $currentaddIns.id)
            $complexProperties = @()
            foreach ($currentProperties in $currentaddIns.properties)
            {
                $myProperties = @{}
                $myProperties.Add('Key', $currentProperties.key)
                $myProperties.Add('Value', $currentProperties.value)
                if ($myProperties.values.Where({$null -ne $_}).count -gt 0)
                {
                    $complexProperties += $myProperties
                }
            }
            $myaddIns.Add('Properties',$complexProperties)
            $myaddIns.Add('Type', $currentaddIns.type)
            if ($myaddIns.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexAddIns += $myaddIns
            }
        }

        $complexAppRoles = @()
        foreach ($currentappRoles in $getValue.AdditionalProperties.appRoles)
        {
            $myappRoles = @{}
            $myappRoles.Add('AllowedMemberTypes', $currentappRoles.allowedMemberTypes)
            $myappRoles.Add('Description', $currentappRoles.description)
            $myappRoles.Add('DisplayName', $currentappRoles.displayName)
            $myappRoles.Add('Id', $currentappRoles.id)
            $myappRoles.Add('IsEnabled', $currentappRoles.isEnabled)
            $myappRoles.Add('Origin', $currentappRoles.origin)
            $myappRoles.Add('Value', $currentappRoles.value)
            if ($myappRoles.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexAppRoles += $myappRoles
            }
        }

        $complexCustomSecurityAttributes = @{}
        if ($complexCustomSecurityAttributes.values.Where({$null -ne $_}).count -eq 0)
        {
            $complexCustomSecurityAttributes = $null
        }

        $complexInfo = @{}
        $complexInfo.Add('LogoUrl', $getValue.AdditionalProperties.info.logoUrl)
        $complexInfo.Add('MarketingUrl', $getValue.AdditionalProperties.info.marketingUrl)
        $complexInfo.Add('PrivacyStatementUrl', $getValue.AdditionalProperties.info.privacyStatementUrl)
        $complexInfo.Add('SupportUrl', $getValue.AdditionalProperties.info.supportUrl)
        $complexInfo.Add('TermsOfServiceUrl', $getValue.AdditionalProperties.info.termsOfServiceUrl)
        if ($complexInfo.values.Where({$null -ne $_}).count -eq 0)
        {
            $complexInfo = $null
        }

        $complexKeyCredentials = @()
        foreach ($currentkeyCredentials in $getValue.AdditionalProperties.keyCredentials)
        {
            $mykeyCredentials = @{}
            $mykeyCredentials.Add('CustomKeyIdentifier', $currentkeyCredentials.customKeyIdentifier)
            $mykeyCredentials.Add('DisplayName', $currentkeyCredentials.displayName)
            if ($null -ne $currentkeyCredentials.endDateTime)
            {
                $mykeyCredentials.Add('EndDateTime', ([DateTimeOffset]$currentkeyCredentials.endDateTime).ToString('o'))
            }
            $mykeyCredentials.Add('Key', $currentkeyCredentials.key)
            $mykeyCredentials.Add('KeyId', $currentkeyCredentials.keyId)
            if ($null -ne $currentkeyCredentials.startDateTime)
            {
                $mykeyCredentials.Add('StartDateTime', ([DateTimeOffset]$currentkeyCredentials.startDateTime).ToString('o'))
            }
            $mykeyCredentials.Add('Type', $currentkeyCredentials.type)
            $mykeyCredentials.Add('Usage', $currentkeyCredentials.usage)
            if ($mykeyCredentials.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexKeyCredentials += $mykeyCredentials
            }
        }

        $complexOauth2PermissionScopes = @()
        foreach ($currentoauth2PermissionScopes in $getValue.AdditionalProperties.oauth2PermissionScopes)
        {
            $myoauth2PermissionScopes = @{}
            $myoauth2PermissionScopes.Add('AdminConsentDescription', $currentoauth2PermissionScopes.adminConsentDescription)
            $myoauth2PermissionScopes.Add('AdminConsentDisplayName', $currentoauth2PermissionScopes.adminConsentDisplayName)
            $myoauth2PermissionScopes.Add('Id', $currentoauth2PermissionScopes.id)
            $myoauth2PermissionScopes.Add('IsEnabled', $currentoauth2PermissionScopes.isEnabled)
            $myoauth2PermissionScopes.Add('Origin', $currentoauth2PermissionScopes.origin)
            $myoauth2PermissionScopes.Add('Type', $currentoauth2PermissionScopes.type)
            $myoauth2PermissionScopes.Add('UserConsentDescription', $currentoauth2PermissionScopes.userConsentDescription)
            $myoauth2PermissionScopes.Add('UserConsentDisplayName', $currentoauth2PermissionScopes.userConsentDisplayName)
            $myoauth2PermissionScopes.Add('Value', $currentoauth2PermissionScopes.value)
            if ($myoauth2PermissionScopes.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexOauth2PermissionScopes += $myoauth2PermissionScopes
            }
        }

        $complexPasswordCredentials = @()
        foreach ($currentpasswordCredentials in $getValue.AdditionalProperties.passwordCredentials)
        {
            $mypasswordCredentials = @{}
            $mypasswordCredentials.Add('CustomKeyIdentifier', $currentpasswordCredentials.customKeyIdentifier)
            $mypasswordCredentials.Add('DisplayName', $currentpasswordCredentials.displayName)
            if ($null -ne $currentpasswordCredentials.endDateTime)
            {
                $mypasswordCredentials.Add('EndDateTime', ([DateTimeOffset]$currentpasswordCredentials.endDateTime).ToString('o'))
            }
            $mypasswordCredentials.Add('Hint', $currentpasswordCredentials.hint)
            $mypasswordCredentials.Add('KeyId', $currentpasswordCredentials.keyId)
            $mypasswordCredentials.Add('SecretText', $currentpasswordCredentials.secretText)
            if ($null -ne $currentpasswordCredentials.startDateTime)
            {
                $mypasswordCredentials.Add('StartDateTime', ([DateTimeOffset]$currentpasswordCredentials.startDateTime).ToString('o'))
            }
            if ($mypasswordCredentials.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexPasswordCredentials += $mypasswordCredentials
            }
        }

        $complexResourceSpecificApplicationPermissions = @()
        foreach ($currentresourceSpecificApplicationPermissions in $getValue.AdditionalProperties.resourceSpecificApplicationPermissions)
        {
            $myresourceSpecificApplicationPermissions = @{}
            $myresourceSpecificApplicationPermissions.Add('Description', $currentresourceSpecificApplicationPermissions.description)
            $myresourceSpecificApplicationPermissions.Add('DisplayName', $currentresourceSpecificApplicationPermissions.displayName)
            $myresourceSpecificApplicationPermissions.Add('Id', $currentresourceSpecificApplicationPermissions.id)
            $myresourceSpecificApplicationPermissions.Add('IsEnabled', $currentresourceSpecificApplicationPermissions.isEnabled)
            $myresourceSpecificApplicationPermissions.Add('Value', $currentresourceSpecificApplicationPermissions.value)
            if ($myresourceSpecificApplicationPermissions.values.Where({$null -ne $_}).count -gt 0)
            {
                $complexResourceSpecificApplicationPermissions += $myresourceSpecificApplicationPermissions
            }
        }

        $complexSamlSingleSignOnSettings = @{}
        $complexSamlSingleSignOnSettings.Add('RelayState', $getValue.AdditionalProperties.samlSingleSignOnSettings.relayState)
        if ($complexSamlSingleSignOnSettings.values.Where({$null -ne $_}).count -eq 0)
        {
            $complexSamlSingleSignOnSettings = $null
        }

        $complexVerifiedPublisher = @{}
        if ($null -ne $getValue.AdditionalProperties.verifiedPublisher.addedDateTime)
        {
            $complexVerifiedPublisher.Add('AddedDateTime', ([DateTimeOffset]$getValue.AdditionalProperties.verifiedPublisher.addedDateTime).ToString('o'))
        }
        $complexVerifiedPublisher.Add('DisplayName', $getValue.AdditionalProperties.verifiedPublisher.displayName)
        $complexVerifiedPublisher.Add('VerifiedPublisherId', $getValue.AdditionalProperties.verifiedPublisher.verifiedPublisherId)
        if ($complexVerifiedPublisher.values.Where({$null -ne $_}).count -eq 0)
        {
            $complexVerifiedPublisher = $null
        }
        #endregion

        #region resource generator code
        $dateDeletedDateTime = $null
        if ($null -ne $getValue.DeletedDateTime)
        {
            $dateDeletedDateTime = ([DateTimeOffset]$getValue.DeletedDateTime).ToString('o')
        }
        #endregion

        $results = @{
            #region resource generator code
            AccountEnabled                         = $getValue.AdditionalProperties.accountEnabled
            AddIns                                 = $complexAddIns
            AlternativeNames                       = $getValue.AdditionalProperties.alternativeNames
            AppDescription                         = $getValue.AdditionalProperties.appDescription
            AppDisplayName                         = $getValue.AdditionalProperties.appDisplayName
            AppId                                  = $getValue.AdditionalProperties.appId
            ApplicationTemplateId                  = $getValue.AdditionalProperties.applicationTemplateId
            AppOwnerOrganizationId                 = $getValue.AdditionalProperties.appOwnerOrganizationId
            AppRoleAssignmentRequired              = $getValue.AdditionalProperties.appRoleAssignmentRequired
            AppRoles                               = $complexAppRoles
            CustomSecurityAttributes               = $complexCustomSecurityAttributes
            Description                            = $getValue.AdditionalProperties.description
            DisabledByMicrosoftStatus              = $getValue.AdditionalProperties.disabledByMicrosoftStatus
            DisplayName                            = $getValue.AdditionalProperties.displayName
            Homepage                               = $getValue.AdditionalProperties.homepage
            Info                                   = $complexInfo
            KeyCredentials                         = $complexKeyCredentials
            LoginUrl                               = $getValue.AdditionalProperties.loginUrl
            LogoutUrl                              = $getValue.AdditionalProperties.logoutUrl
            Notes                                  = $getValue.AdditionalProperties.notes
            NotificationEmailAddresses             = $getValue.AdditionalProperties.notificationEmailAddresses
            Oauth2PermissionScopes                 = $complexOauth2PermissionScopes
            PasswordCredentials                    = $complexPasswordCredentials
            PreferredSingleSignOnMode              = $getValue.AdditionalProperties.preferredSingleSignOnMode
            PreferredTokenSigningKeyThumbprint     = $getValue.AdditionalProperties.preferredTokenSigningKeyThumbprint
            ReplyUrls                              = $getValue.AdditionalProperties.replyUrls
            ResourceSpecificApplicationPermissions = $complexResourceSpecificApplicationPermissions
            SamlSingleSignOnSettings               = $complexSamlSingleSignOnSettings
            ServicePrincipalNames                  = $getValue.AdditionalProperties.servicePrincipalNames
            ServicePrincipalType                   = $getValue.AdditionalProperties.servicePrincipalType
            SignInAudience                         = $getValue.AdditionalProperties.signInAudience
            Tags                                   = $getValue.AdditionalProperties.tags
            TokenEncryptionKeyId                   = $getValue.AdditionalProperties.tokenEncryptionKeyId
            VerifiedPublisher                      = $complexVerifiedPublisher
            DeletedDateTime                        = $dateDeletedDateTime
            Id                                     = $getValue.Id
            Ensure                                 = 'Present'
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            ApplicationSecret                      = $ApplicationSecret
            CertificateThumbprint                  = $CertificateThumbprint
            Managedidentity                        = $ManagedIdentity.IsPresent
            #endregion
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AddIns,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.String]
        $AppDescription,

        [Parameter()]
        [System.String]
        $AppDisplayName,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.String]
        $ApplicationTemplateId,

        [Parameter()]
        [System.Guid]
        $AppOwnerOrganizationId,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppRoles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CustomSecurityAttributes,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisabledByMicrosoftStatus,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Info,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KeyCredentials,

        [Parameter()]
        [System.String]
        $LoginUrl,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String[]]
        $NotificationEmailAddresses,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Oauth2PermissionScopes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PasswordCredentials,

        [Parameter()]
        [System.String]
        $PreferredSingleSignOnMode,

        [Parameter()]
        [System.String]
        $PreferredTokenSigningKeyThumbprint,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ResourceSpecificApplicationPermissions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SamlSingleSignOnSettings,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [System.Guid]
        $TokenEncryptionKeyId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $VerifiedPublisher,

        [Parameter()]
        [System.String]
        $DeletedDateTime,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        #endregion
        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Azure AD Service Principal with DisplayName {$DisplayName}"

        $CreateParameters = ([Hashtable]$BoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        #region resource generator code
        $CreateParameters.Add("@odata.type", "#microsoft.graph.ServicePrincipal")
        $policy = New-MgServicePrincipal -BodyParameter $CreateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Service Principal with Id {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }
        #region resource generator code
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.ServicePrincipal")
        Update-MgServicePrincipal  `
            -ServicePrincipalId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Service Principal with Id {$($currentInstance.Id)}" 
        #region resource generator code
Remove-MgServicePrincipal -ServicePrincipalId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AddIns,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.String]
        $AppDescription,

        [Parameter()]
        [System.String]
        $AppDisplayName,

        [Parameter()]
        [System.String]
        $AppId,

        [Parameter()]
        [System.String]
        $ApplicationTemplateId,

        [Parameter()]
        [System.Guid]
        $AppOwnerOrganizationId,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppRoles,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $CustomSecurityAttributes,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisabledByMicrosoftStatus,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Info,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $KeyCredentials,

        [Parameter()]
        [System.String]
        $LoginUrl,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String[]]
        $NotificationEmailAddresses,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Oauth2PermissionScopes,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $PasswordCredentials,

        [Parameter()]
        [System.String]
        $PreferredSingleSignOnMode,

        [Parameter()]
        [System.String]
        $PreferredTokenSigningKeyThumbprint,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ResourceSpecificApplicationPermissions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SamlSingleSignOnSettings,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String]
        $SignInAudience,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [System.Guid]
        $TokenEncryptionKeyId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $VerifiedPublisher,

        [Parameter()]
        [System.String]
        $DeletedDateTime,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of the Azure AD Service Principal with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.remove('Id') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        [array]$getValue = Get-MgServicePrincipal `
            -All `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id = $config.Id
                DisplayName           =  $config.DisplayName
                Ensure = 'Present'
                Credential = $Credential
                ApplicationId = $ApplicationId
                TenantId = $TenantId
                ApplicationSecret = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($null -ne $Results.AddIns)
            {
                $complexMapping = @(
                    @{
                        Name = 'AddIns'
                        CimInstanceName = 'MicrosoftGraphAddIn'
                        IsRequired = $False
                    }
                    @{
                        Name = 'Properties'
                        CimInstanceName = 'MicrosoftGraphKeyValue'
                        IsRequired = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AddIns `
                    -CIMInstanceName 'MicrosoftGraphaddIn' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AddIns = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AddIns') | Out-Null
                }
            }
            if ($null -ne $Results.AppRoles)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AppRoles `
                    -CIMInstanceName 'MicrosoftGraphappRole'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AppRoles = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AppRoles') | Out-Null
                }
            }
            if ($null -ne $Results.CustomSecurityAttributes)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.CustomSecurityAttributes `
                    -CIMInstanceName 'MicrosoftGraphcustomSecurityAttributeValue'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.CustomSecurityAttributes = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CustomSecurityAttributes') | Out-Null
                }
            }
            if ($null -ne $Results.Info)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Info `
                    -CIMInstanceName 'MicrosoftGraphinformationalUrl'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Info = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Info') | Out-Null
                }
            }
            if ($null -ne $Results.KeyCredentials)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.KeyCredentials `
                    -CIMInstanceName 'MicrosoftGraphkeyCredential'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.KeyCredentials = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('KeyCredentials') | Out-Null
                }
            }
            if ($null -ne $Results.Oauth2PermissionScopes)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Oauth2PermissionScopes `
                    -CIMInstanceName 'MicrosoftGraphpermissionScope'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Oauth2PermissionScopes = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Oauth2PermissionScopes') | Out-Null
                }
            }
            if ($null -ne $Results.PasswordCredentials)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.PasswordCredentials `
                    -CIMInstanceName 'MicrosoftGraphpasswordCredential'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.PasswordCredentials = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('PasswordCredentials') | Out-Null
                }
            }
            if ($null -ne $Results.ResourceSpecificApplicationPermissions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ResourceSpecificApplicationPermissions `
                    -CIMInstanceName 'MicrosoftGraphresourceSpecificPermission'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ResourceSpecificApplicationPermissions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ResourceSpecificApplicationPermissions') | Out-Null
                }
            }
            if ($null -ne $Results.SamlSingleSignOnSettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.SamlSingleSignOnSettings `
                    -CIMInstanceName 'MicrosoftGraphsamlSingleSignOnSettings'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.SamlSingleSignOnSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('SamlSingleSignOnSettings') | Out-Null
                }
            }
            if ($null -ne $Results.VerifiedPublisher)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.VerifiedPublisher `
                    -CIMInstanceName 'MicrosoftGraphverifiedPublisher'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.VerifiedPublisher = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('VerifiedPublisher') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($Results.AddIns)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "AddIns" -isCIMArray:$True
            }
            if ($Results.AppRoles)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "AppRoles" -isCIMArray:$True
            }
            if ($Results.CustomSecurityAttributes)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "CustomSecurityAttributes" -isCIMArray:$False
            }
            if ($Results.Info)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Info" -isCIMArray:$False
            }
            if ($Results.KeyCredentials)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "KeyCredentials" -isCIMArray:$True
            }
            if ($Results.Oauth2PermissionScopes)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Oauth2PermissionScopes" -isCIMArray:$True
            }
            if ($Results.PasswordCredentials)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "PasswordCredentials" -isCIMArray:$True
            }
            if ($Results.ResourceSpecificApplicationPermissions)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "ResourceSpecificApplicationPermissions" -isCIMArray:$True
            }
            if ($Results.SamlSingleSignOnSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "SamlSingleSignOnSettings" -isCIMArray:$False
            }
            if ($Results.VerifiedPublisher)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "VerifiedPublisher" -isCIMArray:$False
            }

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
