param(
    [string]$CredentialsFile = ".\1password-credentials.json",
    [string]$Namespace = "external-secrets",
    [string]$Token,
    [switch]$CreateTokenFromOp,
    [string]$ConnectServerName = "Kubernetes",
    [string]$Vault = "K3s",
    [string]$TokenName = "external-secret-operator",
    [string]$TokenSecretName = "onepassword-connect-token",
    [string]$LegacyTokenSecretName = "external-secret-operator"
)

$ErrorActionPreference = "Stop"

function Require-Command {
    param([string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command '$Name' was not found on PATH."
    }
}

function Invoke-KubectlYamlApply {
    param([string[]]$Arguments)

    $yaml = & kubectl @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "kubectl $($Arguments -join ' ') failed with exit code $LASTEXITCODE."
    }

    $yaml | & kubectl apply -f - | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "kubectl apply -f - failed with exit code $LASTEXITCODE."
    }
}

function Ensure-Namespace {
    param([string]$Name)

    $existing = & kubectl get namespace $Name --ignore-not-found -o name 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to check namespace '$Name'."
    }

    if (-not [string]::IsNullOrWhiteSpace($existing)) {
        return
    }

    & kubectl create namespace $Name | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create namespace '$Name'."
    }

    Write-Host "Created namespace '$Name'."
}

Require-Command kubectl
Ensure-Namespace -Name $Namespace

if (-not (Test-Path $CredentialsFile)) {
    throw "Credentials file '$CredentialsFile' was not found."
}

$rawCredentials = Get-Content -Path $CredentialsFile -Raw
if ([string]::IsNullOrWhiteSpace($rawCredentials)) {
    throw "Credentials file '$CredentialsFile' is empty."
}

$encodedCredentials = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($rawCredentials))

$opCredentialsArgs = @(
    'create', 'secret', 'generic', 'op-credentials',
    '-n', $Namespace,
    "--from-literal=1password-credentials.json=$encodedCredentials",
    '--dry-run=client', '-o', 'yaml'
)

Invoke-KubectlYamlApply -Arguments $opCredentialsArgs

Write-Host "Configured secret 'op-credentials' in namespace '$Namespace'."

if ($CreateTokenFromOp) {
    Require-Command op
    $Token = op connect token create $TokenName --server $ConnectServerName --vault $Vault
}

if ($Token) {
    $tokenSecretNames = @($TokenSecretName)
    if ($LegacyTokenSecretName -and ($LegacyTokenSecretName -ne $TokenSecretName)) {
        $tokenSecretNames += $LegacyTokenSecretName
    }

    foreach ($secretName in $tokenSecretNames) {
        $tokenArgs = @(
            'create', 'secret', 'generic', $secretName,
            '-n', $Namespace,
            "--from-literal=token=$Token",
            '--dry-run=client', '-o', 'yaml'
        )

        Invoke-KubectlYamlApply -Arguments $tokenArgs
        Write-Host "Configured secret '$secretName' in namespace '$Namespace'."
    }
}
else {
    Write-Warning "No token was provided. Token secrets '$TokenSecretName' and '$LegacyTokenSecretName' were not created. Use -Token or -CreateTokenFromOp."
}

Write-Host "1Password Connect secret bootstrap completed."