# Secure Credentials & Sensitive Data Management

Guide for securely managing keystores, passwords, and API keys for Bengali Heroes production release.

## 🔐 Keystore Management

### Generating Production Keystore

#### Step 1: Open PowerShell as Administrator

```powershell
# Navigate to Android directory
cd "$env:USERPROFILE\.android"
```

#### Step 2: Generate Keystore

```powershell
keytool -genkey -v -keystore bengal_heroes_release.jks `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias bengal_heroes_key
```

**When prompted (CRITICAL - Write these down):**

```
Enter keystore password: [CREATE STRONG PASSWORD - MIN 12 CHARS]
Re-enter keystore password: [CONFIRM]
What is your first name and last name? [Your Name]
What is your organizational unit name? [Development Team]
What is your organization name? [Bengal Heroes]
What is your City or Locality name? [Your City]
What is your State or Province name? [Your State]
What is the two-letter country code for this unit? [IN]
Is CN=YourName, OU=Dev Team, O=Bengal Heroes, L=City, ST=State, C=IN correct? [yes]
Enter key password for <bengal_heroes_key>: [CREATE STRONG PASSWORD - MIN 12 CHARS]
```

#### Step 3: Verify Keystore Created

```powershell
keytool -list -v -keystore bengal_heroes_release.jks
```

Should show certificate details with fingerprint.

### Secure Storage Setup

#### 1. **Never** Store Credentials in Code

❌ **WRONG**:
```dart
const String KEYSTORE_PASSWORD = "mypassword123";  // NEVER!
```

✅ **RIGHT**: Use environment variables only.

#### 2. Create Encrypted `.env.release` File

In project root (NOT in git):

```env
# Bengal Heroes - Production Release Credentials
# NEVER COMMIT THIS FILE TO VERSION CONTROL
# Add to .gitignore: .env.release

KEYSTORE_PATH=C:\Users\YourUsername\.android\bengal_heroes_release.jks
KEYSTORE_PASSWORD=YourStrongKeystorePassword123!
KEY_ALIAS=bengal_heroes_key
KEY_PASSWORD=YourStrongKeyPassword123!
```

#### 3. Update `.gitignore`

```text
# Sensitive files
.env*
!.env.example
*.jks
*.keystore
*.p12
*.pfx

# Credentials
.credentials
secrets/
```

#### 4. Create `.env.example` (Safe Template)

```env
# Bengal Heroes - Production Release Credentials Template
# Copy this to .env.release and fill in your actual credentials

KEYSTORE_PATH=/path/to/bengal_heroes_release.jks
KEYSTORE_PASSWORD=your_keystore_password_here
KEY_ALIAS=bengal_heroes_key
KEY_PASSWORD=your_key_password_here
```

### Backup Strategy

#### 1. Create Secure Backup Folder

```powershell
# Create encrypted backup location
$BackupPath = "$env:USERPROFILE\AppData\Local\BengalHeroesBackup"
New-Item -ItemType Directory -Path $BackupPath -Force

# Copy keystore
Copy-Item "$env:USERPROFILE\.android\bengal_heroes_release.jks" $BackupPath
```

#### 2. Encrypt Backup (Windows)

```powershell
# Right-click backup folder → Properties → Advanced
# Check "Encrypt contents to secure data"
# Click OK → Apply changes to folder and contents
```

#### 3. Document Credentials Securely

Create `backup_credentials.txt` (encrypted):

```
Bengal Heroes - Production Keystore Information
Generated: February 14, 2026

IMPORTANT: This file is encrypted. Do not share.

Keystore: bengal_heroes_release.jks
Location: C:\Users\YourUsername\.android\

Key Alias: bengal_heroes_key
Validity: 10000 days (until ~2053)

Certificate Fingerprint (SHA-1):
[Copy from keytool -list output]

Certificate Fingerprint (SHA-256):
[Copy from keytool -list output]

Recovery Information:
- Backup location: [Your backup path]
- Backup date: [Date]
- Backup encrypted: Yes
- Stored offline: [Yes/No]
```

## 🛡️ Environment Variable Setup

### Windows (Temporary - Command Prompt)

```cmd
set KEYSTORE_PATH=C:\Users\YourUsername\.android\bengal_heroes_release.jks
set KEYSTORE_PASSWORD=YourPassword123!
set KEY_ALIAS=bengal_heroes_key
set KEY_PASSWORD=YourPassword123!

flutter build appbundle --release
```

### Windows (Temporary - PowerShell)

```powershell
$env:KEYSTORE_PATH = "C:\Users\YourUsername\.android\bengal_heroes_release.jks"
$env:KEYSTORE_PASSWORD = "YourPassword123!"
$env:KEY_ALIAS = "bengal_heroes_key"
$env:KEY_PASSWORD = "YourPassword123!"

flutter build appbundle --release
```

### Windows (Persistent - User Environment Variables)

```powershell
# View current variables
[Environment]::GetEnvironmentVariables("User")

# Add new variable
[Environment]::SetEnvironmentVariable("KEYSTORE_PATH", 
    "C:\Users\YourUsername\.android\bengal_heroes_release.jks",
    "User")

# Restart terminal for changes to take effect
```

**⚠️ WARNING**: Persistent environment variables visible to all apps. Only use if necessary.

### CI/CD Pipelines (GitHub Actions)

```yaml
# In GitHub repository settings → Secrets → New repository secret

KEYSTORE_PATH=${{ secrets.KEYSTORE_PATH }}
KEYSTORE_PASSWORD=${{ secrets.KEYSTORE_PASSWORD }}
KEY_ALIAS=${{ secrets.KEY_ALIAS }}
KEY_PASSWORD=${{ secrets.KEY_PASSWORD }}
```

## 🔑 Credential Rotation

### When to Rotate

- Annually (security best practice)
- If password suspected compromised
- When team member leaves
- After security audit

### Rotation Process

#### Step 1: Generate New Keystore

```powershell
keytool -genkey -v -keystore bengal_heroes_release_v2.jks `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias bengal_heroes_key_v2
```

#### Step 2: Export Old Certificate (For reference)

```powershell
keytool -export -v -cert -alias bengal_heroes_key `
  -file old_cert.cer `
  -keystore bengal_heroes_release.jks
```

#### Step 3: Update Configuration

- Update `KEYSTORE_PATH` to new keystore
- Update credentials in `.env.release`
- Update GitHub secrets (if using CI/CD)

#### Step 4: Test New Keystore

```powershell
$env:KEYSTORE_PATH = "C:\Users\user\.android\bengal_heroes_release_v2.jks"
$env:KEYSTORE_PASSWORD = "NewPassword123!"
$env:KEY_ALIAS = "bengal_heroes_key_v2"
$env:KEY_PASSWORD = "NewPassword123!"

flutter build appbundle --release
```

#### Step 5: Archive Old Keystore

- Backup old keystore securely
- Keep for 1 year minimum
- Label with rotation date
- Store encrypted offline

## 🔏 Password Security Best Practices

### Strong Password Requirements

✅ **Good**:
- `Bh@2024SecureKey567!Prod`
- `BengalHeroes_Release_2024!`
- `Q9xK2mP7vL@Release2024p`

❌ **Bad**:
- `123456` (too simple)
- `password` (dictionary word)
- `bengal1234` (predictable)
- `qwerty` (keyboard pattern)

### Password Manager Integration

#### Using KeePass (Free)

```
1. Download KeePass from keepass.info
2. Create database: BengalHeroes.kdbx
3. Add entries:
   - Title: Bengal Heroes Keystore
   - Username: bengal_heroes_key
   - Password: [Strong password]
   - URL: [Keystore path]
4. Save to encrypted location
```

#### Using LastPass / 1Password

Create secure vault:
- Password: [Strong password]
- Username: Your email
- Notes: [Keystore path and details]
- Store offline backup

## 🚨 Incident Response

### If Keystore Password Forgotten

```powershell
# Keystore cannot be recovered. You MUST:

# 1. Create new keystore (process above)
# 2. Get new signing certificate fingerprint
# 3. Update Google Play Console settings
# 4. Release under new signing key (new app version)
```

### If Keystore File Lost

```powershell
# 1. Check backups:
cd "$env:USERPROFILE\AppData\Local\BengalHeroesBackup"

# 2. If not found, recreate entire signing process
# 3. This means new release under different signing key
```

### If Credentials Leaked

**IMMEDIATE ACTION**:

```powershell
# 1. Create new keystore immediately
# 2. Stop all ongoing releases
# 3. Update all passwords
# 4. Audit recent builds
# 5. Deploy hotfix with new keystore
# 6. Notify users if necessary
```

## 📊 Credential Audit Log

Create `credentials_audit.log`:

```
2024-02-14 10:00 - Initial keystore created
2024-02-14 11:30 - Test build successful
2024-02-15 09:00 - Production release v1.0.0
2024-02-15 14:00 - Monitored rollout
2025-02-14 10:00 - Annual password rotation (PLAN)
```

## 🔐 Zero-Trust Security Model

Even with proper setup, always:

1. **Never Commit** credentials to version control
2. **Never Email** passwords in plain text
3. **Never Log** sensitive data
4. **Never Share Keystore** file directly
5. **Never Use Debug** keystores in production

### CI/CD Secret Management

If using automated builds:

```yaml
# GitHub Actions Example
- name: Build Release AAB
  env:
    KEYSTORE_PATH: ${{ secrets.KEYSTORE_PATH }}
    KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
    KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
    KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
  run: flutter build appbundle --release
```

GitHub secrets are:
- ✅ Encrypted at rest
- ✅ Masked in logs
- ✅ Isolated per branch
- ✅ Audit logged

## 📋 Security Checklist

- [ ] Keystore created with strong password
- [ ] Keystore file backed up encrypted
- [ ] Credentials file not in git
- [ ] `.env*` added to `.gitignore`
- [ ] `.env.example` created as template
- [ ] Credentials documented securely
- [ ] Password manager tested
- [ ] Environment variables set correctly
- [ ] Test build completed successfully
- [ ] Real-world build tested (on device)
- [ ] All backups verified readable
- [ ] Team access documented
- [ ] Incident response plan created
- [ ] Annual rotation schedule set
- [ ] Password rotation reminder set

## 📞 Troubleshooting

### "Keystore not found"
```powershell
# 1. Verify KEYSTORE_PATH is correct
$env:KEYSTORE_PATH  # Should show full path

# 2. List keystores
Get-ChildItem "$env:USERPROFILE\.android\"

# 3. Verify file exists
Test-Path $env:KEYSTORE_PATH
```

### "Wrong password"
```powershell
# Verify keystores's password:
keytool -list -v -keystore bengal_heroes_release.jks

# If locked, wait 1 hour before retrying
# If consistently fails, keystore may be corrupted
```

### "Key alias not found"
```powershell
# List all aliases in keystore
keytool -list -keystore bengal_heroes_release.jks

# Correct alias: bengal_heroes_key (case-sensitive)
```

---

**Remember**: The keystore is your digital identity. Protect it like your bank account! 🔐️

For questions: Consult Google Play Console documentation or Android developer docs.
