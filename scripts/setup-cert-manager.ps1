#Requires -Version 5.0
<#
.SYNOPSIS
	Installs cert-manager and Istio CSR dependencies for the local k3d cluster.
.DESCRIPTION
	Adds the Jetstack Helm repo, installs cert-manager and cert-manager-istio-csr,
	applies the Istio CA certificate, and installs Istio with the local operator config.
#>

$ErrorActionPreference = 'Stop'

# Always run from the repo root regardless of where the script was invoked.
Set-Location -Path "$PSScriptRoot\.."

function Invoke-Native {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Command,
		[string[]]$Arguments = @()
	)

	& $Command @Arguments
	if ($LASTEXITCODE -ne 0) {
		throw "'$Command $($Arguments -join ' ')' exited with code $LASTEXITCODE."
	}
}

function Ensure-Namespace {
	param([Parameter(Mandatory = $true)][string]$Name)

	$existing = & kubectl get namespace $Name --ignore-not-found -o name 2>$null
	if ($LASTEXITCODE -ne 0) {
		throw "Failed to check namespace '$Name'."
	}

	if (-not [string]::IsNullOrWhiteSpace($existing)) {
		Write-Host "Namespace '$Name' already exists. Skipping." -ForegroundColor Yellow
		return
	}

	Invoke-Native kubectl @('create', 'namespace', $Name)
}

function Install-OrUpgradeHelmRelease {
	param(
		[Parameter(Mandatory = $true)][string]$Namespace,
		[Parameter(Mandatory = $true)][string]$Release,
		[Parameter(Mandatory = $true)][string]$Chart,
		[string[]]$ExtraArgs = @()
	)

	$args = @('upgrade', '--install', '-n', $Namespace, $Release, $Chart) + $ExtraArgs
	Invoke-Native helm $args
}

Write-Host "`n==> Adding and updating Jetstack Helm repository" -ForegroundColor Cyan
Invoke-Native helm @('repo', 'add', 'jetstack', 'https://charts.jetstack.io')
Invoke-Native helm @('repo', 'update')

Write-Host "`n==> Installing cert-manager" -ForegroundColor Cyan
Ensure-Namespace -Name 'cert-manager'
Install-OrUpgradeHelmRelease -Namespace 'cert-manager' -Release 'cert-manager' -Chart 'jetstack/cert-manager' -ExtraArgs @('--set', 'installCRDs=true')

Write-Host "`n==> Applying Istio certificate resources" -ForegroundColor Cyan
Ensure-Namespace -Name 'istio-system'
Invoke-Native kubectl @('apply', '-n', 'istio-system', '-f', '.\k3d-cluster\cluster\istio-cert.yaml')

Write-Host "`n==> Installing cert-manager-istio-csr" -ForegroundColor Cyan
Install-OrUpgradeHelmRelease -Namespace 'cert-manager' -Release 'cert-manager-istio-csr' -Chart 'jetstack/cert-manager-istio-csr'
Invoke-Native kubectl @('rollout', 'status', 'deployment/cert-manager-istio-csr', '-n', 'cert-manager', '--timeout=180s')

Write-Host "`ncert-manager and Istio setup completed." -ForegroundColor Green