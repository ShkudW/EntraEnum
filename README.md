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
Invoke-EntraEnum -domain <domain> -AccessToken <access-token> -devices
Invoke-EntraEnum -domain <domain> -AccessToken <access-token> -roles
Invoke-EntraEnum -domain <domain> -AccessToken <access-token> -signins
Invoke-EntraEnum -domain <domain> -AccessToken <access-token> -subscriptions
Invoke-EntraEnum -domain <domain> -AccessToken <access-token> -contacts
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

## PoC

![image](https://github.com/user-attachments/assets/c3e8c49b-82a2-415b-8c25-080d0e1f9a5e)

![image](https://github.com/user-attachments/assets/e83db57a-daf5-482d-b2f3-90fa251882a5)

![image](https://github.com/user-attachments/assets/84f9a18f-6fae-4230-b73a-3652c3494130)

![image](https://github.com/user-attachments/assets/2297e744-2bba-4a8b-9d19-ed2b720aa15c)

![image](https://github.com/user-attachments/assets/4affbd73-eb98-4b49-bcfc-1bcc6a896ad8)

![image](https://github.com/user-attachments/assets/477b0eec-dba6-42a6-8a44-dab90991bb23)





