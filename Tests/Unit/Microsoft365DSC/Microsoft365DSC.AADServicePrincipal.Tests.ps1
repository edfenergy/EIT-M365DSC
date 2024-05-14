[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath '..\..\Unit' `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath '\Stubs\Microsoft365.psm1' `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath '\Stubs\Generic.psm1' `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "AADServicePrincipal" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgServicePrincipal -MockWith {
            }

            Mock -CommandName New-MgServicePrincipal -MockWith {
            }

            Mock -CommandName Remove-MgServicePrincipal -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The AADServicePrincipal should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountEnabled = $True
                    addIns = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaddIn -Property @{
                            type = "FakeStringValue"
                            properties = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphkeyValue -Property @{
                                    value = "FakeStringValue"
                                    key = "FakeStringValue"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    alternativeNames = @("FakeStringValue")
                    appDescription = "FakeStringValue"
                    appDisplayName = "FakeStringValue"
                    appId = "FakeStringValue"
                    applicationTemplateId = "FakeStringValue"
                    appRoleAssignmentRequired = $True
                    appRoles = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphappRole -Property @{
                            description = "FakeStringValue"
                            value = "FakeStringValue"
                            displayName = "FakeStringValue"
                            allowedMemberTypes = @("FakeStringValue")
                            origin = "FakeStringValue"
                            isEnabled = $True
                        } -ClientOnly)
                    )
                    customSecurityAttributes = (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSecurityAttributeValue -Property @{
                        Name = "CustomSecurityAttributes"
                        isArray = $False
                        CIMType = "MSFT_MicrosoftGraphcustomSecurityAttributeValue"
                    } -ClientOnly)
                    deletedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    description = "FakeStringValue"
                    disabledByMicrosoftStatus = "FakeStringValue"
                    displayName = "FakeStringValue"
                    homepage = "FakeStringValue"
                    id = "FakeStringValue"
                    info = (New-CimInstance -ClassName MSFT_MicrosoftGraphinformationalUrl -Property @{
                        privacyStatementUrl = "FakeStringValue"
                        termsOfServiceUrl = "FakeStringValue"
                        logoUrl = "FakeStringValue"
                        supportUrl = "FakeStringValue"
                        marketingUrl = "FakeStringValue"
                    } -ClientOnly)
                    keyCredentials = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphkeyCredential -Property @{
                            startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            displayName = "FakeStringValue"
                            endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            type = "FakeStringValue"
                            usage = "FakeStringValue"
                        } -ClientOnly)
                    )
                    loginUrl = "FakeStringValue"
                    logoutUrl = "FakeStringValue"
                    notes = "FakeStringValue"
                    notificationEmailAddresses = @("FakeStringValue")
                    oauth2PermissionScopes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphpermissionScope -Property @{
                            userConsentDescription = "FakeStringValue"
                            value = "FakeStringValue"
                            isEnabled = $True
                            adminConsentDescription = "FakeStringValue"
                            adminConsentDisplayName = "FakeStringValue"
                            origin = "FakeStringValue"
                            userConsentDisplayName = "FakeStringValue"
                            type = "FakeStringValue"
                        } -ClientOnly)
                    )
                    passwordCredentials = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphpasswordCredential -Property @{
                            displayName = "FakeStringValue"
                            startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            hint = "FakeStringValue"
                            secretText = "FakeStringValue"
                            endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        } -ClientOnly)
                    )
                    preferredSingleSignOnMode = "FakeStringValue"
                    preferredTokenSigningKeyThumbprint = "FakeStringValue"
                    replyUrls = @("FakeStringValue")
                    resourceSpecificApplicationPermissions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphresourceSpecificPermission -Property @{
                            displayName = "FakeStringValue"
                            value = "FakeStringValue"
                            isEnabled = $True
                            description = "FakeStringValue"
                        } -ClientOnly)
                    )
                    samlSingleSignOnSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphsamlSingleSignOnSettings -Property @{
                        relayState = "FakeStringValue"
                    } -ClientOnly)
                    servicePrincipalNames = @("FakeStringValue")
                    servicePrincipalType = "FakeStringValue"
                    signInAudience = "FakeStringValue"
                    tags = @("FakeStringValue")
                    verifiedPublisher = (New-CimInstance -ClassName MSFT_MicrosoftGraphverifiedPublisher -Property @{
                        verifiedPublisherId = "FakeStringValue"
                        addedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        displayName = "FakeStringValue"
                    } -ClientOnly)
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgServicePrincipal -Exactly 1
            }
        }

        Context -Name "The AADServicePrincipal exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountEnabled = $True
                    addIns = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaddIn -Property @{
                            type = "FakeStringValue"
                            properties = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphkeyValue -Property @{
                                    value = "FakeStringValue"
                                    key = "FakeStringValue"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    alternativeNames = @("FakeStringValue")
                    appDescription = "FakeStringValue"
                    appDisplayName = "FakeStringValue"
                    appId = "FakeStringValue"
                    applicationTemplateId = "FakeStringValue"
                    appRoleAssignmentRequired = $True
                    appRoles = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphappRole -Property @{
                            description = "FakeStringValue"
                            value = "FakeStringValue"
                            displayName = "FakeStringValue"
                            allowedMemberTypes = @("FakeStringValue")
                            origin = "FakeStringValue"
                            isEnabled = $True
                        } -ClientOnly)
                    )
                    customSecurityAttributes = (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSecurityAttributeValue -Property @{
                        Name = "CustomSecurityAttributes"
                        isArray = $False
                        CIMType = "MSFT_MicrosoftGraphcustomSecurityAttributeValue"
                    } -ClientOnly)
                    deletedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    description = "FakeStringValue"
                    disabledByMicrosoftStatus = "FakeStringValue"
                    displayName = "FakeStringValue"
                    homepage = "FakeStringValue"
                    id = "FakeStringValue"
                    info = (New-CimInstance -ClassName MSFT_MicrosoftGraphinformationalUrl -Property @{
                        privacyStatementUrl = "FakeStringValue"
                        termsOfServiceUrl = "FakeStringValue"
                        logoUrl = "FakeStringValue"
                        supportUrl = "FakeStringValue"
                        marketingUrl = "FakeStringValue"
                    } -ClientOnly)
                    keyCredentials = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphkeyCredential -Property @{
                            startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            displayName = "FakeStringValue"
                            endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            type = "FakeStringValue"
                            usage = "FakeStringValue"
                        } -ClientOnly)
                    )
                    loginUrl = "FakeStringValue"
                    logoutUrl = "FakeStringValue"
                    notes = "FakeStringValue"
                    notificationEmailAddresses = @("FakeStringValue")
                    oauth2PermissionScopes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphpermissionScope -Property @{
                            userConsentDescription = "FakeStringValue"
                            value = "FakeStringValue"
                            isEnabled = $True
                            adminConsentDescription = "FakeStringValue"
                            adminConsentDisplayName = "FakeStringValue"
                            origin = "FakeStringValue"
                            userConsentDisplayName = "FakeStringValue"
                            type = "FakeStringValue"
                        } -ClientOnly)
                    )
                    passwordCredentials = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphpasswordCredential -Property @{
                            displayName = "FakeStringValue"
                            startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            hint = "FakeStringValue"
                            secretText = "FakeStringValue"
                            endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        } -ClientOnly)
                    )
                    preferredSingleSignOnMode = "FakeStringValue"
                    preferredTokenSigningKeyThumbprint = "FakeStringValue"
                    replyUrls = @("FakeStringValue")
                    resourceSpecificApplicationPermissions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphresourceSpecificPermission -Property @{
                            displayName = "FakeStringValue"
                            value = "FakeStringValue"
                            isEnabled = $True
                            description = "FakeStringValue"
                        } -ClientOnly)
                    )
                    samlSingleSignOnSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphsamlSingleSignOnSettings -Property @{
                        relayState = "FakeStringValue"
                    } -ClientOnly)
                    servicePrincipalNames = @("FakeStringValue")
                    servicePrincipalType = "FakeStringValue"
                    signInAudience = "FakeStringValue"
                    tags = @("FakeStringValue")
                    verifiedPublisher = (New-CimInstance -ClassName MSFT_MicrosoftGraphverifiedPublisher -Property @{
                        verifiedPublisherId = "FakeStringValue"
                        addedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        displayName = "FakeStringValue"
                    } -ClientOnly)
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AdditionalProperties = @{
                            resourceSpecificApplicationPermissions = @(
                                @{
                                    displayName = "FakeStringValue"
                                    value = "FakeStringValue"
                                    isEnabled = $True
                                    description = "FakeStringValue"
                                }
                            )
                            customSecurityAttributes = @{
                                Name = "CustomSecurityAttributes"
                                isArray = $False
                            }
                            info = @{
                                privacyStatementUrl = "FakeStringValue"
                                termsOfServiceUrl = "FakeStringValue"
                                logoUrl = "FakeStringValue"
                                supportUrl = "FakeStringValue"
                                marketingUrl = "FakeStringValue"
                            }
                            tags = @("FakeStringValue")
                            oauth2PermissionScopes = @(
                                @{
                                    userConsentDescription = "FakeStringValue"
                                    value = "FakeStringValue"
                                    isEnabled = $True
                                    adminConsentDescription = "FakeStringValue"
                                    adminConsentDisplayName = "FakeStringValue"
                                    origin = "FakeStringValue"
                                    userConsentDisplayName = "FakeStringValue"
                                    type = "FakeStringValue"
                                }
                            )
                            logoutUrl = "FakeStringValue"
                            loginUrl = "FakeStringValue"
                            accountEnabled = $True
                            passwordCredentials = @(
                                @{
                                    displayName = "FakeStringValue"
                                    startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    hint = "FakeStringValue"
                                    secretText = "FakeStringValue"
                                    endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                }
                            )
                            homepage = "FakeStringValue"
                            appId = "FakeStringValue"
                            appRoles = @(
                                @{
                                    description = "FakeStringValue"
                                    value = "FakeStringValue"
                                    displayName = "FakeStringValue"
                                    allowedMemberTypes = @("FakeStringValue")
                                    origin = "FakeStringValue"
                                    isEnabled = $True
                                }
                            )
                            appDisplayName = "FakeStringValue"
                            preferredTokenSigningKeyThumbprint = "FakeStringValue"
                            notes = "FakeStringValue"
                            alternativeNames = @("FakeStringValue")
                            servicePrincipalNames = @("FakeStringValue")
                            replyUrls = @("FakeStringValue")
                            appDescription = "FakeStringValue"
                            displayName = "FakeStringValue"
                            verifiedPublisher = @{
                                verifiedPublisherId = "FakeStringValue"
                                addedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                displayName = "FakeStringValue"
                            }
                            signInAudience = "FakeStringValue"
                            addIns = @(
                                @{
                                    type = "FakeStringValue"
                                    properties = @(
                                        @{
                                            value = "FakeStringValue"
                                            key = "FakeStringValue"
                                        }
                                    )
                                }
                            )
                            applicationTemplateId = "FakeStringValue"
                            description = "FakeStringValue"
                            appRoleAssignmentRequired = $True
                            '@odata.type' = "#microsoft.graph.ServicePrincipal"
                            keyCredentials = @(
                                @{
                                    startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    displayName = "FakeStringValue"
                                    endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    type = "FakeStringValue"
                                    usage = "FakeStringValue"
                                }
                            )
                            preferredSingleSignOnMode = "FakeStringValue"
                            servicePrincipalType = "FakeStringValue"
                            notificationEmailAddresses = @("FakeStringValue")
                            disabledByMicrosoftStatus = "FakeStringValue"
                            samlSingleSignOnSettings = @{
                                relayState = "FakeStringValue"
                            }
                        }
                        deletedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        id = "FakeStringValue"

                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgServicePrincipal -Exactly 1
            }
        }
        Context -Name "The AADServicePrincipal Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountEnabled = $True
                    addIns = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaddIn -Property @{
                            type = "FakeStringValue"
                            properties = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphkeyValue -Property @{
                                    value = "FakeStringValue"
                                    key = "FakeStringValue"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    alternativeNames = @("FakeStringValue")
                    appDescription = "FakeStringValue"
                    appDisplayName = "FakeStringValue"
                    appId = "FakeStringValue"
                    applicationTemplateId = "FakeStringValue"
                    appRoleAssignmentRequired = $True
                    appRoles = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphappRole -Property @{
                            description = "FakeStringValue"
                            value = "FakeStringValue"
                            displayName = "FakeStringValue"
                            allowedMemberTypes = @("FakeStringValue")
                            origin = "FakeStringValue"
                            isEnabled = $True
                        } -ClientOnly)
                    )
                    customSecurityAttributes = (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSecurityAttributeValue -Property @{
                        Name = "CustomSecurityAttributes"
                        isArray = $False
                        CIMType = "MSFT_MicrosoftGraphcustomSecurityAttributeValue"
                    } -ClientOnly)
                    deletedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    description = "FakeStringValue"
                    disabledByMicrosoftStatus = "FakeStringValue"
                    displayName = "FakeStringValue"
                    homepage = "FakeStringValue"
                    id = "FakeStringValue"
                    info = (New-CimInstance -ClassName MSFT_MicrosoftGraphinformationalUrl -Property @{
                        privacyStatementUrl = "FakeStringValue"
                        termsOfServiceUrl = "FakeStringValue"
                        logoUrl = "FakeStringValue"
                        supportUrl = "FakeStringValue"
                        marketingUrl = "FakeStringValue"
                    } -ClientOnly)
                    keyCredentials = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphkeyCredential -Property @{
                            startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            displayName = "FakeStringValue"
                            endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            type = "FakeStringValue"
                            usage = "FakeStringValue"
                        } -ClientOnly)
                    )
                    loginUrl = "FakeStringValue"
                    logoutUrl = "FakeStringValue"
                    notes = "FakeStringValue"
                    notificationEmailAddresses = @("FakeStringValue")
                    oauth2PermissionScopes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphpermissionScope -Property @{
                            userConsentDescription = "FakeStringValue"
                            value = "FakeStringValue"
                            isEnabled = $True
                            adminConsentDescription = "FakeStringValue"
                            adminConsentDisplayName = "FakeStringValue"
                            origin = "FakeStringValue"
                            userConsentDisplayName = "FakeStringValue"
                            type = "FakeStringValue"
                        } -ClientOnly)
                    )
                    passwordCredentials = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphpasswordCredential -Property @{
                            displayName = "FakeStringValue"
                            startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            hint = "FakeStringValue"
                            secretText = "FakeStringValue"
                            endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        } -ClientOnly)
                    )
                    preferredSingleSignOnMode = "FakeStringValue"
                    preferredTokenSigningKeyThumbprint = "FakeStringValue"
                    replyUrls = @("FakeStringValue")
                    resourceSpecificApplicationPermissions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphresourceSpecificPermission -Property @{
                            displayName = "FakeStringValue"
                            value = "FakeStringValue"
                            isEnabled = $True
                            description = "FakeStringValue"
                        } -ClientOnly)
                    )
                    samlSingleSignOnSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphsamlSingleSignOnSettings -Property @{
                        relayState = "FakeStringValue"
                    } -ClientOnly)
                    servicePrincipalNames = @("FakeStringValue")
                    servicePrincipalType = "FakeStringValue"
                    signInAudience = "FakeStringValue"
                    tags = @("FakeStringValue")
                    verifiedPublisher = (New-CimInstance -ClassName MSFT_MicrosoftGraphverifiedPublisher -Property @{
                        verifiedPublisherId = "FakeStringValue"
                        addedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        displayName = "FakeStringValue"
                    } -ClientOnly)
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AdditionalProperties = @{
                            resourceSpecificApplicationPermissions = @(
                                @{
                                    displayName = "FakeStringValue"
                                    value = "FakeStringValue"
                                    isEnabled = $True
                                    description = "FakeStringValue"
                                }
                            )
                            customSecurityAttributes = @{
                                Name = "CustomSecurityAttributes"
                                isArray = $False
                            }
                            info = @{
                                privacyStatementUrl = "FakeStringValue"
                                termsOfServiceUrl = "FakeStringValue"
                                logoUrl = "FakeStringValue"
                                supportUrl = "FakeStringValue"
                                marketingUrl = "FakeStringValue"
                            }
                            tags = @("FakeStringValue")
                            oauth2PermissionScopes = @(
                                @{
                                    userConsentDescription = "FakeStringValue"
                                    value = "FakeStringValue"
                                    isEnabled = $True
                                    adminConsentDescription = "FakeStringValue"
                                    adminConsentDisplayName = "FakeStringValue"
                                    origin = "FakeStringValue"
                                    userConsentDisplayName = "FakeStringValue"
                                    type = "FakeStringValue"
                                }
                            )
                            logoutUrl = "FakeStringValue"
                            loginUrl = "FakeStringValue"
                            accountEnabled = $True
                            passwordCredentials = @(
                                @{
                                    displayName = "FakeStringValue"
                                    startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    hint = "FakeStringValue"
                                    secretText = "FakeStringValue"
                                    endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                }
                            )
                            homepage = "FakeStringValue"
                            appId = "FakeStringValue"
                            appRoles = @(
                                @{
                                    description = "FakeStringValue"
                                    value = "FakeStringValue"
                                    displayName = "FakeStringValue"
                                    allowedMemberTypes = @("FakeStringValue")
                                    origin = "FakeStringValue"
                                    isEnabled = $True
                                }
                            )
                            appDisplayName = "FakeStringValue"
                            preferredTokenSigningKeyThumbprint = "FakeStringValue"
                            notes = "FakeStringValue"
                            alternativeNames = @("FakeStringValue")
                            servicePrincipalNames = @("FakeStringValue")
                            replyUrls = @("FakeStringValue")
                            appDescription = "FakeStringValue"
                            displayName = "FakeStringValue"
                            verifiedPublisher = @{
                                verifiedPublisherId = "FakeStringValue"
                                addedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                displayName = "FakeStringValue"
                            }
                            signInAudience = "FakeStringValue"
                            addIns = @(
                                @{
                                    type = "FakeStringValue"
                                    properties = @(
                                        @{
                                            value = "FakeStringValue"
                                            key = "FakeStringValue"
                                        }
                                    )
                                }
                            )
                            applicationTemplateId = "FakeStringValue"
                            description = "FakeStringValue"
                            appRoleAssignmentRequired = $True
                            '@odata.type' = "#microsoft.graph.ServicePrincipal"
                            keyCredentials = @(
                                @{
                                    startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    displayName = "FakeStringValue"
                                    endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    type = "FakeStringValue"
                                    usage = "FakeStringValue"
                                }
                            )
                            preferredSingleSignOnMode = "FakeStringValue"
                            servicePrincipalType = "FakeStringValue"
                            notificationEmailAddresses = @("FakeStringValue")
                            disabledByMicrosoftStatus = "FakeStringValue"
                            samlSingleSignOnSettings = @{
                                relayState = "FakeStringValue"
                            }
                        }
                        deletedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        id = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADServicePrincipal exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccountEnabled = $True
                    addIns = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphaddIn -Property @{
                            type = "FakeStringValue"
                            properties = [CimInstance[]]@(
                                (New-CimInstance -ClassName MSFT_MicrosoftGraphkeyValue -Property @{
                                    value = "FakeStringValue"
                                    key = "FakeStringValue"
                                } -ClientOnly)
                            )
                        } -ClientOnly)
                    )
                    alternativeNames = @("FakeStringValue")
                    appDescription = "FakeStringValue"
                    appDisplayName = "FakeStringValue"
                    appId = "FakeStringValue"
                    applicationTemplateId = "FakeStringValue"
                    appRoleAssignmentRequired = $True
                    appRoles = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphappRole -Property @{
                            description = "FakeStringValue"
                            value = "FakeStringValue"
                            displayName = "FakeStringValue"
                            allowedMemberTypes = @("FakeStringValue")
                            origin = "FakeStringValue"
                            isEnabled = $True
                        } -ClientOnly)
                    )
                    customSecurityAttributes = (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSecurityAttributeValue -Property @{
                        Name = "CustomSecurityAttributes"
                        isArray = $False
                        CIMType = "MSFT_MicrosoftGraphcustomSecurityAttributeValue"
                    } -ClientOnly)
                    deletedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                    description = "FakeStringValue"
                    disabledByMicrosoftStatus = "FakeStringValue"
                    displayName = "FakeStringValue"
                    homepage = "FakeStringValue"
                    id = "FakeStringValue"
                    info = (New-CimInstance -ClassName MSFT_MicrosoftGraphinformationalUrl -Property @{
                        privacyStatementUrl = "FakeStringValue"
                        termsOfServiceUrl = "FakeStringValue"
                        logoUrl = "FakeStringValue"
                        supportUrl = "FakeStringValue"
                        marketingUrl = "FakeStringValue"
                    } -ClientOnly)
                    keyCredentials = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphkeyCredential -Property @{
                            startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            displayName = "FakeStringValue"
                            endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            type = "FakeStringValue"
                            usage = "FakeStringValue"
                        } -ClientOnly)
                    )
                    loginUrl = "FakeStringValue"
                    logoutUrl = "FakeStringValue"
                    notes = "FakeStringValue"
                    notificationEmailAddresses = @("FakeStringValue")
                    oauth2PermissionScopes = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphpermissionScope -Property @{
                            userConsentDescription = "FakeStringValue"
                            value = "FakeStringValue"
                            isEnabled = $True
                            adminConsentDescription = "FakeStringValue"
                            adminConsentDisplayName = "FakeStringValue"
                            origin = "FakeStringValue"
                            userConsentDisplayName = "FakeStringValue"
                            type = "FakeStringValue"
                        } -ClientOnly)
                    )
                    passwordCredentials = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphpasswordCredential -Property @{
                            displayName = "FakeStringValue"
                            startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                            hint = "FakeStringValue"
                            secretText = "FakeStringValue"
                            endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        } -ClientOnly)
                    )
                    preferredSingleSignOnMode = "FakeStringValue"
                    preferredTokenSigningKeyThumbprint = "FakeStringValue"
                    replyUrls = @("FakeStringValue")
                    resourceSpecificApplicationPermissions = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_MicrosoftGraphresourceSpecificPermission -Property @{
                            displayName = "FakeStringValue"
                            value = "FakeStringValue"
                            isEnabled = $True
                            description = "FakeStringValue"
                        } -ClientOnly)
                    )
                    samlSingleSignOnSettings = (New-CimInstance -ClassName MSFT_MicrosoftGraphsamlSingleSignOnSettings -Property @{
                        relayState = "FakeStringValue"
                    } -ClientOnly)
                    servicePrincipalNames = @("FakeStringValue")
                    servicePrincipalType = "FakeStringValue"
                    signInAudience = "FakeStringValue"
                    tags = @("FakeStringValue")
                    verifiedPublisher = (New-CimInstance -ClassName MSFT_MicrosoftGraphverifiedPublisher -Property @{
                        verifiedPublisherId = "FakeStringValue"
                        addedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        displayName = "FakeStringValue"
                    } -ClientOnly)
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AdditionalProperties = @{
                            resourceSpecificApplicationPermissions = @(
                                @{
                                    value = "FakeStringValue"
                                    displayName = "FakeStringValue"
                                    description = "FakeStringValue"
                                }
                            )
                            tags = @("FakeStringValue")
                            info = @{
                                privacyStatementUrl = "FakeStringValue"
                                termsOfServiceUrl = "FakeStringValue"
                                logoUrl = "FakeStringValue"
                                supportUrl = "FakeStringValue"
                                marketingUrl = "FakeStringValue"
                            }
                            customSecurityAttributes = @{
                                Name = "CustomSecurityAttributes"
                                isArray = $False
                            }
                            logoutUrl = "FakeStringValue"
                            oauth2PermissionScopes = @(
                                @{
                                    value = "FakeStringValue"
                                    userConsentDescription = "FakeStringValue"
                                    adminConsentDescription = "FakeStringValue"
                                    userConsentDisplayName = "FakeStringValue"
                                    origin = "FakeStringValue"
                                    adminConsentDisplayName = "FakeStringValue"
                                    type = "FakeStringValue"
                                }
                            )
                            loginUrl = "FakeStringValue"
                            preferredTokenSigningKeyThumbprint = "FakeStringValue"
                            passwordCredentials = @(
                                @{
                                    displayName = "FakeStringValue"
                                    startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    hint = "FakeStringValue"
                                    secretText = "FakeStringValue"
                                    endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                }
                            )
                            appRoles = @(
                                @{
                                    origin = "FakeStringValue"
                                    allowedMemberTypes = @("FakeStringValue")
                                    value = "FakeStringValue"
                                    description = "FakeStringValue"
                                    displayName = "FakeStringValue"
                                }
                            )
                            appId = "FakeStringValue"
                            homepage = "FakeStringValue"
                            appDisplayName = "FakeStringValue"
                            alternativeNames = @("FakeStringValue")
                            notes = "FakeStringValue"
                            appDescription = "FakeStringValue"
                            replyUrls = @("FakeStringValue")
                            verifiedPublisher = @{
                                verifiedPublisherId = "FakeStringValue"
                                addedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                displayName = "FakeStringValue"
                            }
                            applicationTemplateId = "FakeStringValue"
                            addIns = @(
                                @{
                                    type = "FakeStringValue"
                                    properties = @(
                                        @{
                                            value = "FakeStringValue"
                                            key = "FakeStringValue"
                                        }
                                    )
                                }
                            )
                            signInAudience = "FakeStringValue"
                            description = "FakeStringValue"
                            displayName = "FakeStringValue"
                            preferredSingleSignOnMode = "FakeStringValue"
                            keyCredentials = @(
                                @{
                                    startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    displayName = "FakeStringValue"
                                    endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    type = "FakeStringValue"
                                    usage = "FakeStringValue"
                                }
                            )
                            servicePrincipalNames = @("FakeStringValue")
                            disabledByMicrosoftStatus = "FakeStringValue"
                            notificationEmailAddresses = @("FakeStringValue")
                            servicePrincipalType = "FakeStringValue"
                            samlSingleSignOnSettings = @{
                                relayState = "FakeStringValue"
                            }
                        }
                        deletedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        id = "FakeStringValue"
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgServicePrincipal -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AdditionalProperties = @{
                            resourceSpecificApplicationPermissions = @(
                                @{
                                    displayName = "FakeStringValue"
                                    value = "FakeStringValue"
                                    isEnabled = $True
                                    description = "FakeStringValue"
                                }
                            )
                            customSecurityAttributes = @{
                                Name = "CustomSecurityAttributes"
                                isArray = $False
                            }
                            info = @{
                                privacyStatementUrl = "FakeStringValue"
                                termsOfServiceUrl = "FakeStringValue"
                                logoUrl = "FakeStringValue"
                                supportUrl = "FakeStringValue"
                                marketingUrl = "FakeStringValue"
                            }
                            tags = @("FakeStringValue")
                            oauth2PermissionScopes = @(
                                @{
                                    userConsentDescription = "FakeStringValue"
                                    value = "FakeStringValue"
                                    isEnabled = $True
                                    adminConsentDescription = "FakeStringValue"
                                    adminConsentDisplayName = "FakeStringValue"
                                    origin = "FakeStringValue"
                                    userConsentDisplayName = "FakeStringValue"
                                    type = "FakeStringValue"
                                }
                            )
                            logoutUrl = "FakeStringValue"
                            loginUrl = "FakeStringValue"
                            accountEnabled = $True
                            passwordCredentials = @(
                                @{
                                    displayName = "FakeStringValue"
                                    startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    hint = "FakeStringValue"
                                    secretText = "FakeStringValue"
                                    endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                }
                            )
                            homepage = "FakeStringValue"
                            appId = "FakeStringValue"
                            appRoles = @(
                                @{
                                    description = "FakeStringValue"
                                    value = "FakeStringValue"
                                    displayName = "FakeStringValue"
                                    allowedMemberTypes = @("FakeStringValue")
                                    origin = "FakeStringValue"
                                    isEnabled = $True
                                }
                            )
                            appDisplayName = "FakeStringValue"
                            preferredTokenSigningKeyThumbprint = "FakeStringValue"
                            notes = "FakeStringValue"
                            alternativeNames = @("FakeStringValue")
                            servicePrincipalNames = @("FakeStringValue")
                            replyUrls = @("FakeStringValue")
                            appDescription = "FakeStringValue"
                            displayName = "FakeStringValue"
                            verifiedPublisher = @{
                                verifiedPublisherId = "FakeStringValue"
                                addedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                displayName = "FakeStringValue"
                            }
                            signInAudience = "FakeStringValue"
                            addIns = @(
                                @{
                                    type = "FakeStringValue"
                                    properties = @(
                                        @{
                                            value = "FakeStringValue"
                                            key = "FakeStringValue"
                                        }
                                    )
                                }
                            )
                            applicationTemplateId = "FakeStringValue"
                            description = "FakeStringValue"
                            appRoleAssignmentRequired = $True
                            '@odata.type' = "#microsoft.graph.ServicePrincipal"
                            keyCredentials = @(
                                @{
                                    startDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    displayName = "FakeStringValue"
                                    endDateTime = "2023-01-01T00:00:00.0000000+00:00"
                                    type = "FakeStringValue"
                                    usage = "FakeStringValue"
                                }
                            )
                            preferredSingleSignOnMode = "FakeStringValue"
                            servicePrincipalType = "FakeStringValue"
                            notificationEmailAddresses = @("FakeStringValue")
                            disabledByMicrosoftStatus = "FakeStringValue"
                            samlSingleSignOnSettings = @{
                                relayState = "FakeStringValue"
                            }
                        }
                        deletedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        id = "FakeStringValue"

                    }
                }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
