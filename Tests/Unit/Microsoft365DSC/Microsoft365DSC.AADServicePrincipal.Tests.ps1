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
    -DscResource 'AADServicePrincipal' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@contoso.com', $secpasswd)


            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgServicePrincipal -MockWith {
            }

            Mock -CommandName Remove-MgServicePrincipal -MockWith {
            }

            Mock -CommandName New-MgServicePrincipal -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The service principal should exist but it does not' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                     = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834'
                    DisplayName               = 'App1'
                    AlternativeNames          = 'AlternativeName1', 'AlternativeName2'
                    AccountEnabled            = $true
                    AppRoleAssignmentRequired = $false
                    customSecurityAttributes  = (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSecurityAttributeValue -Property @{
                        Name = "CustomSecurityAttributes"
                        isArray = $False
                        CIMType = "MSFT_MicrosoftGraphcustomSecurityAttributeValue"
                    } -ClientOnly)
                    ErrorUrl                  = ''
                    Homepage                  = 'https://app1.contoso.com'
                    LogoutUrl                 = 'https://app1.contoso.com/logout'
                    PublisherName             = 'Contoso'
                    ReplyURLs                 = 'https://app1.contoso.com'
                    SamlMetadataURL           = ''
                    ServicePrincipalNames     = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834', 'https://app1.contoso.com'
                    ServicePrincipalType      = 'Application'
                    Tags                      = '{WindowsAzureActiveDirectoryIntegratedApp}'
                    Ensure                    = 'Present'
                    Credential                = $Credscredential
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return $null
                }
            }

            It 'Should return values from the get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName 'Get-MgServicePrincipal' -Exactly 1
            }
            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should create the application from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgServicePrincipal' -Exactly 1
            }
        }

        Context -Name 'The application exists but it should not' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                     = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834'
                    DisplayName               = 'App1'
                    AlternativeNames          = 'AlternativeName1', 'AlternativeName2'
                    AccountEnabled            = $true
                    AppRoleAssignmentRequired = $false
                    customSecurityAttributes  = (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSecurityAttributeValue -Property @{
                        Name = "CustomSecurityAttributes"
                        isArray = $False
                        CIMType = "MSFT_MicrosoftGraphcustomSecurityAttributeValue"
                    } -ClientOnly)
                    ErrorUrl                  = ''
                    Homepage                  = 'https://app1.contoso.com'
                    LogoutUrl                 = 'https://app1.contoso.com/logout'
                    PublisherName             = 'Contoso'
                    ReplyURLs                 = 'https://app1.contoso.com'
                    SamlMetadataURL           = ''
                    ServicePrincipalNames     = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834', 'https://app1.contoso.com'
                    ServicePrincipalType      = 'Application'
                    Tags                      = '{WindowsAzureActiveDirectoryIntegratedApp}'
                    Ensure                    = 'Absent'
                    Credential                = $Credscredential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AppId                        = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834'
                        Id                          = '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                        DisplayName                  = 'App1'
                        AlternativeNames             = 'AlternativeName1', 'AlternativeName2'
                        AccountEnabled               = $true
                        AppRoleAssignmentRequired    = $false
                        customSecurityAttributes = @{
                            Name = "CustomSecurityAttributes"
                            isArray = $False
                        }
                        ErrorUrl                     = ''
                        Homepage                     = 'https://app1.contoso.com'
                        LogoutUrl                    = 'https://app1.contoso.com/logout'
                        PublisherName                = 'Contoso'
                        ReplyURLs                    = 'https://app1.contoso.com'
                        SamlMetadataURL              = ''
                        ServicePrincipalNames        = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834', 'https://app1.contoso.com'
                        ServicePrincipalType         = 'Application'
                        Tags                         = '{WindowsAzureActiveDirectoryIntegratedApp}'
                    }
                }
            }

            It 'Should return values from the get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName 'Get-MgServicePrincipal' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the app from the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Remove-MgServicePrincipal' -Exactly 1
            }
        }
        Context -Name 'The app exists and values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                     = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834'
                    DisplayName               = 'App1'
                    AlternativeNames          = 'AlternativeName1', 'AlternativeName2'
                    AccountEnabled            = $true
                    AppRoleAssignmentRequired = $false
                    customSecurityAttributes = (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSecurityAttributeValue -Property @{
                        Name = "CustomSecurityAttributes"
                        isArray = $False
                        CIMType = "MSFT_MicrosoftGraphcustomSecurityAttributeValue"
                    } -ClientOnly)
                    ErrorUrl                  = ''
                    Homepage                  = 'https://app1.contoso.com'
                    LogoutUrl                 = 'https://app1.contoso.com/logout'
                    PublisherName             = 'Contoso'
                    ReplyURLs                 = 'https://app1.contoso.com'
                    SamlMetadataURL           = ''
                    ServicePrincipalNames     = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834', 'https://app1.contoso.com'
                    ServicePrincipalType      = 'Application'
                    Tags                      = '{WindowsAzureActiveDirectoryIntegratedApp}'
                    Ensure                    = 'Present'
                    Credential                = $Credscredential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AppId                        = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834'
                        Id                          = '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                        DisplayName                  = 'App1'
                        AlternativeNames             = 'AlternativeName1', 'AlternativeName2'
                        AccountEnabled               = $true
                        AppRoleAssignmentRequired    = $false
                        customSecurityAttributes = @{
                            Name = "CustomSecurityAttributes"
                            isArray = $False
                        }
                        ErrorUrl                     = ''
                        Homepage                     = 'https://app1.contoso.com'
                        LogoutUrl                    = 'https://app1.contoso.com/logout'
                        PublisherName                = 'Contoso'
                        ReplyURLs                    = 'https://app1.contoso.com'
                        SamlMetadataURL              = ''
                        ServicePrincipalNames        = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834', 'https://app1.contoso.com'
                        ServicePrincipalType         = 'Application'
                        Tags                         = '{WindowsAzureActiveDirectoryIntegratedApp}'
                    }
                }
            }

            It 'Should return Values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgServicePrincipal' -Exactly 1
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Values are not in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    AppId                     = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834'
                    DisplayName               = 'App1'
                    AlternativeNames          = 'AlternativeName1', 'AlternativeName2', 'AlternativeName3' #drift
                    AccountEnabled            = $true
                    AppRoleAssignmentRequired = $false
                    customSecurityAttributes = (New-CimInstance -ClassName MSFT_MicrosoftGraphcustomSecurityAttributeValue -Property @{
                        Name = "CustomSecurityAttributes"
                        isArray = $False
                        CIMType = "MSFT_MicrosoftGraphcustomSecurityAttributeValue"
                    } -ClientOnly)
                    ErrorUrl                  = ''
                    Homepage                  = 'https://app1.contoso.com'
                    LogoutUrl                 = 'https://app1.contoso.com/logout'
                    PublisherName             = 'Contoso'
                    ReplyURLs                 = 'https://app1.contoso.com'
                    SamlMetadataURL           = ''
                    ServicePrincipalNames     = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834', 'https://app1.contoso.com'
                    ServicePrincipalType      = 'Application'
                    Tags                      = '{WindowsAzureActiveDirectoryIntegratedApp}'
                    Ensure                    = 'Present'
                    Credential                = $Credscredential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AppId                        = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834'
                        Id                          = '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                        DisplayName                  = 'App1'
                        AlternativeNames             = 'AlternativeName1', 'AlternativeName2'
                        AccountEnabled               = $true
                        AppRoleAssignmentRequired    = $false
                        customSecurityAttributes = @{
                            Name = "CustomSecurityAttributes"
                            isArray = $False
                        }
                        ErrorUrl                     = ''
                        Homepage                     = 'https://app1.contoso.com'
                        LogoutUrl                    = 'https://app1.contoso.com/logout'
                        PublisherName                = 'Contoso'
                        ReplyURLs                    = 'https://app1.contoso.com'
                        SamlMetadataURL              = ''
                        ServicePrincipalNames        = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834', 'https://app1.contoso.com'
                        ServicePrincipalType         = 'Application'
                        Tags                         = '{WindowsAzureActiveDirectoryIntegratedApp}'
                    }
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgServicePrincipal' -Exactly 1
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgServicePrincipal' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgServicePrincipal -MockWith {
                    return @{
                        AppId                        = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834'
                        Id                          = '5dcb2237-c61b-4258-9c85-eae2aaeba9d6'
                        DisplayName                  = 'App1'
                        AlternativeNames             = 'AlternativeName1', 'AlternativeName2'
                        AccountEnabled               = $true
                        AppRoleAssignmentRequired    = $false
                        customSecurityAttributes = @{
                            Name = "CustomSecurityAttributes"
                            isArray = $False
                        }
                        ErrorUrl                     = ''
                        Homepage                     = 'https://app1.contoso.com'
                        LogoutUrl                    = 'https://app1.contoso.com/logout'
                        PublisherName                = 'Contoso'
                        ReplyURLs                    = 'https://app1.contoso.com'
                        SamlMetadataURL              = ''
                        ServicePrincipalNames        = 'b4f08c68-7276-4cb8-b9ae-e75fca5ff834', 'https://app1.contoso.com'
                        ServicePrincipalType         = 'Application'
                        Tags                         = '{WindowsAzureActiveDirectoryIntegratedApp}'
                    }
                }
            }

            It 'Should reverse engineer resource from the export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
