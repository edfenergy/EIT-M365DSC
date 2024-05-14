<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
        AADServicePrincipal 'Example'
        {
            AccountEnabled            = $True;
            AlternativeNames          = @();
            AppId                     = "b8340c3b-9267-498f-b21a-15d5547fd85e";
            AppRoleAssignedTo         = @();
            AppRoleAssignmentRequired = $False;
            Credential                = $Credscredential;
            DisplayName               = "Hyper-V Recovery Manager";
            Ensure                    = "Present";
            ObjectID                  = "00d59c1c-ab4f-4a38-af2d-7e69dc362ea3";
            ReplyURLs                 = @();
            ServicePrincipalNames     = @("b8340c3b-9267-498f-b21a-15d5547fd85e");
            ServicePrincipalType      = "Application";
            Tags                      = @("disableRequestingTenantedPassthroughTokens","disableAcceptingTenantedPassthroughTokens");
        }
    }
}
