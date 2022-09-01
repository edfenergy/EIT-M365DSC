[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
    -ChildPath "..\..\Unit" `
    -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\Stubs\Microsoft365.psm1" `
        -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\Stubs\Generic.psm1" `
        -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "IntuneSettingCatalogASRRulesPolicyWindows10" -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin", $secpasswd)
            Mock -CommandName Update-M365DSCExportAuthenticationResults -MockWith {
                return @{}
            }

            Mock -CommandName Get-M365DSCExportContentForResource -MockWith {

            }

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {

            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName New-MgDeviceManagementConfigurationPolicy -MockWith {
            }
            Mock -CommandName Update-MgDeviceManagementConfigurationPolicy -MockWith {
            }
            Mock -CommandName Remove-MgDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName Get-MgDeviceManagementConfigurationPolicyTemplate -MockWith {
                return @{
                    TemplateId = 'e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1'
                }
            }
        }

        # Test contexts
        Context -Name "When the policy doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    blockadobereaderfromcreatingchildprocesses                        = "audit";
                    blockallofficeapplicationsfromcreatingchildprocesses              = "warn";
                    blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem = "warn";
                    blockwin32apicallsfromofficemacros                                = "block";
                    Credential                                                        = $Credential;
                    Description                                                       = "My Test";
                    DisplayName                                                       = "asdfads";
                    Ensure                                                            = "Present";
                    Identity                                                          = "a90ca9bc-8a68-4901-a991-dafaa633b034";
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
                    return $null
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicySetting -MockWith {
                    return $null
                }
            }

            It "Should return absent from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should create the policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName "New-MgDeviceManagementConfigurationPolicy" -Exactly 1
            }
        }

        Context -Name "When the policy already exists and is NOT in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    blockadobereaderfromcreatingchildprocesses                        = "audit";
                    blockallofficeapplicationsfromcreatingchildprocesses              = "warn";
                    blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem = "warn";
                    blockwin32apicallsfromofficemacros                                = "block";
                    Credential                                                        = $Credential;
                    Description                                                       = "";
                    DisplayName                                                       = "asdfads";
                    Ensure                                                            = "Present";
                    Identity                                                          = "12345-12345-12345-12345-12345";
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = "My Test";
                        Name = "asdfads";
                    }
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        id                   = "0"
                        SettingDefinitions   = $null
                        SettingInstance      = @(
                            {
                                SettingDefinitionId               = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules"
                                SettingInstanceTemplateReference  = @{
                                    SettingInstanceTemplateId = "19600663-e264-4c02-8f55-f2983216d6d7"
                                }
                                AdditionalProperties = @(
                                    @{
                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                        groupSettingCollectionValue = @(
                                            @{
                                                children = @(
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses_audit"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros_block"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem_block" #drift
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses_warn"
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                )
                            }
                        )
                        AdditionalProperties = @{}
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return false from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should update the policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "When the policy already exists and IS in the Desired State" -Fixture {
            BeforeAll {
                $testParams = @{
                    blockadobereaderfromcreatingchildprocesses                        = "audit";
                    blockallofficeapplicationsfromcreatingchildprocesses              = "warn";
                    blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem = "warn";
                    blockwin32apicallsfromofficemacros                                = "block";
                    Credential                                                        = $Credential;
                    Description                                                       = "My Test";
                    DisplayName                                                       = "asdfads";
                    Ensure                                                            = "Present";
                    Identity                                                          = "12345-12345-12345-12345-12345";
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = "My Test";
                        Name = "asdfads";
                    }
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        id                   = "0"
                        SettingDefinitions   = $null
                        SettingInstance      = @(
                            @{
                                SettingDefinitionId               = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules"
                                SettingInstanceTemplateReference  = @{
                                    SettingInstanceTemplateId = "19600663-e264-4c02-8f55-f2983216d6d7"
                                }
                                AdditionalProperties = @(
                                    @{
                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                        groupSettingCollectionValue = @(
                                            @{
                                                children = @(
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses_audit"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros_block"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem_warn"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses_warn"
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                )
                            }
                        )
                        AdditionalProperties = @{}
                    }
                }
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "When the policy exists and it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    blockadobereaderfromcreatingchildprocesses                        = "audit";
                    blockallofficeapplicationsfromcreatingchildprocesses              = "warn";
                    blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem = "warn";
                    blockwin32apicallsfromofficemacros                                = "block";
                    Credential                                                        = $Credential;
                    Description                                                       = "";
                    DisplayName                                                       = "asdfads";
                    Ensure                                                            = "Absent";
                    Identity                                                          = "12345-12345-12345-12345-12345";
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = "My Test";
                        Name = "asdfads";
                    }
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        id                   = "0"
                        SettingDefinitions   = $null
                        SettingInstance      = @(
                            @{
                                SettingDefinitionId               = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules"
                                SettingInstanceTemplateReference  = @{
                                    SettingInstanceTemplateId = "19600663-e264-4c02-8f55-f2983216d6d7"
                                }
                                AdditionalProperties = @(
                                    @{
                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                        groupSettingCollectionValue = @(
                                            @{
                                                children = @(
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses_audit"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros_block"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem_warn"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses_warn"
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                )
                            }
                        )
                        AdditionalProperties = @{}
                    }
                }
            }

            It "Should return Present from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It "Should return true from the Test method" {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should remove the policy from the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id          = '12345-12345-12345-12345-12345'
                        Description = "My Test";
                        Name = "asdfads";
                    }
                }

                Mock -CommandName Get-MgDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        id                   = "0"
                        SettingDefinitions   = $null
                        SettingInstance      = @(
                            @{
                                SettingDefinitionId               = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules"
                                SettingInstanceTemplateReference  = @{
                                    SettingInstanceTemplateId = "19600663-e264-4c02-8f55-f2983216d6d7"
                                }
                                AdditionalProperties = @(
                                    @{
                                        '@odata.type' = '#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance'
                                        groupSettingCollectionValue = @(
                                            @{
                                                children = @(
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses_audit"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros_block"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem_warn"
                                                        }
                                                    },
                                                    @{
                                                        '@odata.type'     =    '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                                        settingDefinitionId = 'device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses'
                                                        choiceSettingValue  = @{
                                                            value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses_warn"
                                                        }
                                                    }
                                                )
                                            }
                                        )
                                    }
                                )
                            }
                        )
                        AdditionalProperties = @{}
                    }
                }
            }

            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope