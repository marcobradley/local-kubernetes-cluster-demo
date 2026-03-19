param(
    [string]$CredentialsFile = ".\1password-credentials.json",
    [string]$Namespace = "external-secrets",
    [string]$Token,
    [switch]$CreateTokenFromOp = $true,
    [string]$ConnectServerName = "Kubernetes",
    [string]$Vault = "K3s",
    [string]$TokenName = "external-secret-operator",
    [string]$TokenSecretName = "onepassword-connect-token",
    [string]$LegacyTokenSecretName = "external-secret-operator"
)

$ErrorActionPreference = "Stop"

function Invoke-Command {
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

function Find-Namespace {
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

function Resolve-TokenValue {
    param([object]$Value)

    if ($null -eq $Value) {
        return $null
    }

    # Normalize edge cases where command output arrives as character arrays.
    if ($Value -is [char[]]) {
        $Value = -join $Value
    }
    elseif ($Value -is [array] -and $Value.Count -gt 0) {
        $allChars = $true
        foreach ($item in $Value) {
            if ($item -isnot [char]) {
                $allChars = $false
                break
            }
        }

        if ($allChars) {
            $Value = -join $Value
        }
    }

    $lines = @($Value) |
        ForEach-Object { "$_".Trim() } |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    if ($lines.Count -eq 0) {
        return $null
    }

    # If the CLI emits status lines and the token, use the last non-empty line.
    return $lines[-1]
}

Invoke-Command kubectl
Find-Namespace -Name $Namespace

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
Write-Host "Token creation via op CLI enabled: $CreateTokenFromOp"

if ($CreateTokenFromOp) {
    Invoke-Command op

    Write-Host "Creating 1Password Connect token '$TokenName' from server '$ConnectServerName' and vault '$Vault'..."

    # Capture JSON from stdout only so interactive/auth text is not swallowed into token parsing.
    $generatedTokenOutput = op connect token create $TokenName --server $ConnectServerName --vault $Vault
    Write-Host "Raw output from 'op connect token create':"
    Write-Host $generatedTokenOutput
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create 1Password Connect token via 'op connect token create'."
    }

    try {
        $Token = $generatedTokenOutput.Trim()
    }
    catch {
        # Fallback for unexpected CLI output shape.
        $Token = Resolve-TokenValue -Value $generatedTokenOutput
    }

    if ([string]::IsNullOrWhiteSpace($Token)) {
        throw "Token generation succeeded but no token value was returned by the op CLI."
    }
}
else {
    $Token = Resolve-TokenValue -Value $Token
}
Write-Host "Token 'op connect token create':"
Write-Host $Token
if (-not [string]::IsNullOrWhiteSpace($Token)) {
    Write-Host "Token resolved. Preparing Kubernetes secrets in namespace '$Namespace'."
    $tokenSecretNames = @($TokenSecretName)
    if ($LegacyTokenSecretName -and ($LegacyTokenSecretName -ne $TokenSecretName)) {
        $tokenSecretNames += $LegacyTokenSecretName
    }

    Write-Host "Creating token secrets: $($tokenSecretNames -join ', ')"

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