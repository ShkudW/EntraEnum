# EntraEnum
```powershell
  _____       _             _____                       
 | ____|_ __ | |_ _ __ __ _| ____|_ __  _   _ _ __ ___  
 |  _| | '_ \| __| '__/ _` |  _| | '_ \| | | | '_ ` _ \ 
 | |___| | | | |_| | | (_| | |___| | | | |_| | | | | | |
 |_____|_| |_|\__|_|  \__,_|_____|_| |_|\__,_|_| |_| |_|
======================================================= 

```
**EntraEnum** is a PowerShell-based tool designed for enumerating various resources in Azure Active Directory (Entra ID) environments. It allows penetration testers and system administrators to interact with Azure AD APIs, retrieve details about users, groups, applications, and more, while also supporting advanced features like device code phishing and token refresh.

## Features

- **Enumerate Azure AD Resources:** 
  - Users, Groups, Applications, Service Principals, Devices, Roles, Sign-ins, Subscriptions, and Contacts.
  
- **Device Code Phishing:**
  - Generate device codes to phish access tokens from users.

- **Token Management:**
  - Obtain new access and refresh tokens using a refresh token.

## Usage
```powershell
# Retrieve Tenant ID
Invoke-EntraEnum -domain <domain>
```
```powershell
# Enumerating Users, Groups, Applications, etc..
Invoke-EntraEnum -domain <domain> -AccessToken <access-token> -users
Invoke-EntraEnum -domain <domain> -AccessToken <access-token> -groups
Invoke-EntraEnum -domain <domain> -AccessToken <access-token> -applications
```
```powershell
# Generate a device code for phishing
Invoke-EntraEnum -devicecodephishing
```
```powershell
# Retrieve access and refresh tokens after the user inputs the device code
Invoke-EntraEnum -DeviceCodeResults
```
```powershell
# Use a refresh token to obtain new access and refresh tokens
Invoke-Azure -domain <your-domain> -RefreshToken <your-refresh-token>
```



