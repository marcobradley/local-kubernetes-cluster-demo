param(
    [string]$ClusterName = "demo-k3-cluster",
    [string]$BackupDir = ".\backups\demo-k3-cluster-20260323-174207",
    [switch]$IncludePvData,
    [switch]$EnsureCluster,
    [string]$ClusterConfigPath = ".\k3d-cluster\cluster\config.yaml"
)

$ErrorActionPreference = "Stop"

function Require-Command {
    param([string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command '$Name' was not found on PATH."
    }
}

function Test-ClusterExists {
    param([string]$Name)
    $clusters = k3d cluster list -o json | ConvertFrom-Json
    foreach ($cluster in $clusters) {
        if ($cluster.name -eq $Name) {
            return $true
        }
    }
    return $false
}

Require-Command kubectl
Require-Command k3d
Require-Command docker

$serverContainer = "k3d-$ClusterName-server-0"
$dbSource = Join-Path $BackupDir "k3s-server-db"
$pvSource = Join-Path $BackupDir "k3s-storage"

if (-not (Test-Path $BackupDir)) {
    throw "Backup directory not found: $BackupDir"
}

if (-not (Test-Path $dbSource)) {
    throw "Missing required database backup folder: $dbSource"
}

if ($EnsureCluster -and -not (Test-ClusterExists -Name $ClusterName)) {
    if (-not (Test-Path $ClusterConfigPath)) {
        throw "Cluster config not found: $ClusterConfigPath"
    }
    Write-Host "Cluster '$ClusterName' does not exist. Creating from config..."
    k3d cluster create --config $ClusterConfigPath | Out-Null
}

$containerId = docker ps -a --filter "name=^/$serverContainer$" --format "{{.ID}}"
if (-not $containerId) {
    throw "Could not find server container '$serverContainer'. Check cluster name or use -EnsureCluster."
}

Write-Host "[1/5] Stopping cluster '$ClusterName'..."
k3d cluster stop $ClusterName | Out-Null

Write-Host "[2/5] Restoring sqlite datastore from '$dbSource'..."
docker cp "$dbSource\." "${serverContainer}:/var/lib/rancher/k3s/server/db/"

if ($IncludePvData) {
    if (-not (Test-Path $pvSource)) {
        throw "-IncludePvData was set, but backup PV folder not found: $pvSource"
    }
    Write-Host "[3/5] Restoring local-path PV data from '$pvSource'..."
    docker cp "$pvSource\." "${serverContainer}:/var/lib/rancher/k3s/storage/"
}
else {
    Write-Host "[3/5] Skipping PV restore (use -IncludePvData to enable)."
}

Write-Host "[4/5] Starting cluster '$ClusterName'..."
k3d cluster start $ClusterName | Out-Null

Write-Host "[5/5] Validating cluster readiness and key resources..."
kubectl wait --for=condition=Ready node --all --timeout=180s | Out-Null
kubectl get nodes
kubectl get ns

try {
    kubectl get applications.argoproj.io -n argocd
}
catch {
    Write-Warning "Could not list Argo CD applications in namespace 'argocd': $($_.Exception.Message)"
}

kubectl get pods -A

Write-Host "Restore completed from backup: $BackupDir"