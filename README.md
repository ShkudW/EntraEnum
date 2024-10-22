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
Invoke-EntraEnum -AccessToken <access-token> -users
Invoke-EntraEnum -AccessToken <access-token> -groups
Invoke-EntraEnum -AccessToken <access-token> -applications
Invoke-EntraEnum -AccessToken <access-token> -devices
Invoke-EntraEnum -AccessToken <access-token> -roles
Invoke-EntraEnum -AccessToken <access-token> -signins
Invoke-EntraEnum -AccessToken <access-token> -subscriptions
Invoke-EntraEnum -AccessToken <access-token> -contacts
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
Invoke-EntraEnum -domain <domain> -RefreshToken <refresh-token>
```

## Nice to know:
If you see this error: 'API call failed: The remote server returned an error'.
It means you sent too many requests, Wait 30 seconds and resend the request.


## PoC

![image](https://github.com/user-attachments/assets/a5cef64d-3181-4811-ad2a-5739b948d0ee)

![image](https://github.com/user-attachments/assets/0edb98aa-3d7e-41a4-8f6b-91be27f25e41)

![image](https://github.com/user-attachments/assets/a61ff6de-0fa5-46ff-87be-90d8c1edc5f8)

![image](https://github.com/user-attachments/assets/3c9d0c35-6589-4c90-9f01-8faf62d448d2)

![image](https://github.com/user-attachments/assets/888af075-1673-4691-881c-7c794a7d2825)

![image](https://github.com/user-attachments/assets/fd13875c-1da3-465a-a8f1-f80d394b6284)
