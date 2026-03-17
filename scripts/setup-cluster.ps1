#Requires -Version 7.0
<#
.SYNOPSIS
    Creates and bootstraps the local k3d demo cluster.
.DESCRIPTION
    Runs all bootstrap steps in order, waiting for each Argo CD Application
    to become Healthy before proceeding to the next step.
.PARAMETER CredentialsFile
    Path to the 1Password credentials JSON file. Defaults to .\1password-credentials.json.
.PARAMETER Token
    1Password Connect token used to create the token secret.
.PARAMETER CreateTokenFromOp
    If set, generates the Connect token via the 'op' CLI.
#>
param(
    [string]$CredentialsFile = ".\1password-credentials.json",
    [string]$Token,
    [switch]$CreateTokenFromOp
)

$ErrorActionPreference = "Stop"

# Always run from the repo root regardless of where the script was invoked.
Set-Location -Path (Join-Path $PSScriptRoot "..")

function Invoke-Native {
    param([string]$Command, [string[]]$Arguments)
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "'$Command $($Arguments -join ' ')' exited with code $LASTEXITCODE."
    }
}

function Wait-ArgoApp {
    param(
        [string]$Name,
        [int]$TimeoutSeconds = 300
    )
    Write-Host "  Waiting for Argo CD Application '$Name' to become Healthy..." -ForegroundColor Yellow
    Invoke-Native kubectl @(
        'wait', "--for=jsonpath={.status.health.status}=Healthy",
        "application/$Name", '-n', 'argocd', "--timeout=${TimeoutSeconds}s"
    )
}

function Step {
    param([string]$Label)
    Write-Host "`n==> $Label" -ForegroundColor Cyan
}

function Get-ClusterNameFromConfig {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Cluster config '$Path' was not found."
    }

    $metadataName = $null
    $inMetadataBlock = $false

    foreach ($line in Get-Content -Path $Path) {
        if ($line -match '^\s*metadata:\s*$') {
            $inMetadataBlock = $true
            continue
        }

        if ($inMetadataBlock) {
            # If we reach a new top-level key (no indentation) the metadata block is over.
            if ($line -match '^[^\s]') {
                $inMetadataBlock = $false
                continue
            }

            if ($line -match '^\s*name:\s*(.+)\s*$') {
                $metadataName = $Matches[1].Trim()
                # Strip surrounding single or double quotes if present.
                if ($metadataName -match "^([""'])(.*)\1$") {
                    $metadataName = $Matches[2]
                }
                break
            }
        }
    }

    if (-not $metadataName) {
        throw "Unable to determine cluster name from '$Path'. Expected 'metadata.name'."
    }

    return $metadataName
}

function Test-K3dClusterExists {
    param([string]$ClusterName)

    $clusters = & k3d cluster list -o json
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to list k3d clusters."
    }

    if ([string]::IsNullOrWhiteSpace($clusters)) {
        return $false
    }

    $parsed = $clusters | ConvertFrom-Json
    foreach ($cluster in @($parsed)) {
        if ($cluster.name -eq $ClusterName) {
            return $true
        }
    }

    return $false
}

$clusterConfigPath = '.\k3d-cluster\cluster\config.yaml'
$clusterName = Get-ClusterNameFromConfig -Path $clusterConfigPath

# ---------------------------------------------------------------------------
# 1. Create k3d cluster
# ---------------------------------------------------------------------------
Step "Ensuring k3d cluster '$clusterName' exists"
if (Test-K3dClusterExists -ClusterName $clusterName) {
    Write-Host "  Cluster '$clusterName' already exists. Skipping create step." -ForegroundColor Yellow
    Write-Host "  NOTE: Changes to '$clusterConfigPath' (ports, k3s image version, etc.) will NOT be applied to the existing cluster." -ForegroundColor Yellow
    Write-Host "        To apply config changes, delete the cluster first (e.g. 'k3d cluster delete $clusterName') and then rerun this script." -ForegroundColor Yellow
}
else {
    Invoke-Native k3d @('cluster', 'create', '--config', $clusterConfigPath)
}

# Ensure the cluster is running and kubectl points to the k3d context.
Step "Ensuring k3d cluster '$clusterName' is running and kubeconfig context is set"
Invoke-Native k3d @('cluster', 'start', $clusterName)
Invoke-Native k3d @('kubeconfig', 'merge', $clusterName, '--switch-context')

# ---------------------------------------------------------------------------
# 2. Cluster RBAC
# ---------------------------------------------------------------------------
Step "Applying cluster RBAC"
Invoke-Native kubectl @('apply', '-f', '.\k3d-cluster\argocd\apps\app-cluster-rbac.yaml')

# ---------------------------------------------------------------------------
# 3. Argo CD namespace
# ---------------------------------------------------------------------------
Step "Creating argocd namespace"
Invoke-Native kubectl @('apply', '-f', '.\k3d-cluster\cluster\ns-argocd.yaml')

# ---------------------------------------------------------------------------
# 4. Install Argo CD
# ---------------------------------------------------------------------------
Step "Installing Argo CD"
Invoke-Native kubectl @(
    'apply', '-n', 'argocd', '--server-side', '--force-conflicts',
    '-f', 'https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml'
)
Write-Host "  Waiting for argocd-server rollout..." -ForegroundColor Yellow
Invoke-Native kubectl @('rollout', 'status', 'deployment/argocd-server', '-n', 'argocd', '--timeout=180s')

# ---------------------------------------------------------------------------
# 5. Bootstrap 1Password Connect secrets
# ---------------------------------------------------------------------------
Step "Bootstrapping 1Password Connect secrets"
$secretParams = @{ CredentialsFile = $CredentialsFile }
if ($Token)            { $secretParams['Token']             = $Token }
if ($CreateTokenFromOp){ $secretParams['CreateTokenFromOp'] = $true  }
& .\scripts\set-1password-connect-secrets.ps1 @secretParams

# ---------------------------------------------------------------------------
# 6. 1Password Connect
# ---------------------------------------------------------------------------
Step "Applying 1Password Connect"
Invoke-Native kubectl @('apply', '-f', '.\k3d-cluster\argocd\apps\app-1password-connect.yaml')
Wait-ArgoApp -Name '1password-connect'

# ---------------------------------------------------------------------------
# 7. External Secrets Operator
# ---------------------------------------------------------------------------
Step "Applying External Secrets Operator"
Invoke-Native kubectl @('apply', '-f', '.\k3d-cluster\argocd\apps\app-external-secrets-operator.yaml')
Wait-ArgoApp -Name 'external-secrets-operator'

# ---------------------------------------------------------------------------
# 8. External Secrets store
# ---------------------------------------------------------------------------
Step "Applying External Secrets store"
Invoke-Native kubectl @('apply', '-f', '.\k3d-cluster\argocd\apps\app-external-secrets.yaml')
Wait-ArgoApp -Name 'app-external-secrets'

# ---------------------------------------------------------------------------
# 9. Argo CD core configuration
# ---------------------------------------------------------------------------
Step "Applying Argo CD core configuration"
Invoke-Native kubectl @('apply', '-f', '.\k3d-cluster\argocd\apps\app-argocd-core.yaml')
Wait-ArgoApp -Name 'argocd-core-k3d'

Write-Host "  Restarting argocd-server to pick up new secrets..." -ForegroundColor Yellow
Invoke-Native kubectl @('rollout', 'restart', 'deployment/argocd-server', '-n', 'argocd')
Invoke-Native kubectl @('rollout', 'status',  'deployment/argocd-server', '-n', 'argocd', '--timeout=120s')

$encodedPassword = kubectl get secret argocd-initial-admin-secret -n argocd -o 'jsonpath={.data.password}'
$adminPassword   = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($encodedPassword))
Write-Host "`n  Argo CD admin password: $adminPassword" -ForegroundColor Green
Write-Host "  Open https://argocd.localhost:8443 and log in with username 'admin'." -ForegroundColor Green

# ---------------------------------------------------------------------------
# 10-13. Istio (applied in dependency order)
# ---------------------------------------------------------------------------
$istioApps = @(
    @{ File = 'app-istio-base.yaml';    Name = 'istio-base'    }
    @{ File = 'app-istio-cni.yaml';     Name = 'istio-cni'     }
    @{ File = 'app-istiod.yaml';        Name = 'istiod'        }
    @{ File = 'app-istio-ztunnel.yaml'; Name = 'istio-ztunnel' }
)
foreach ($app in $istioApps) {
    Step "Applying $($app.Name)"
    Invoke-Native kubectl @('apply', '-f', ".\k3d-cluster\argocd\apps\$($app.File)")
    Wait-ArgoApp -Name $app.Name
}

# ---------------------------------------------------------------------------
# 14. Dev apps
# ---------------------------------------------------------------------------
Step "Applying dev Argo CD apps"
Invoke-Native kubectl @('apply', '-f', '.\k3d-cluster\argocd\apps\app-argocd-dev.yaml')

Write-Host "`nCluster setup complete!`n" -ForegroundColor Green

