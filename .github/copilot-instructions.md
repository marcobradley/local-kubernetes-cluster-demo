# GitHub Copilot – Security Review Instructions

When reviewing code or configuration in this repository, prioritise the following security concerns.

## Secrets and credentials

- Flag any hardcoded secrets, tokens, passwords, or API keys in source files, Helm values, or manifests.
- Confirm that 1Password Connect and the External Secrets Operator are the only mechanism for injecting secrets into the cluster. Direct `kubectl create secret --from-literal` calls (outside of `scripts/set-1password-connect-secrets.ps1`) should be questioned.
- Ensure secret values are never logged, echoed, or written to output streams.

## Kubernetes RBAC and least privilege

- Roles and ClusterRoles must only grant the minimum verbs and resources needed. Flag wildcards (`*`) in `verbs`, `resources`, or `apiGroups` unless explicitly justified.
- Service accounts should not have cluster-admin or overly broad permissions.
- Review new `ClusterRoleBinding` resources carefully; prefer namespace-scoped `RoleBinding` where possible.

## Container and image security

- Images must use a specific version tag or digest — never `latest`.
- Containers must not run as `root` unless there is a documented, unavoidable reason.
- Flag any missing `securityContext` with `readOnlyRootFilesystem`, `allowPrivilegeEscalation: false`, and `runAsNonRoot: true`.

## Network exposure

- Ingress resources must only expose intended paths and hosts. Wildcards in `host` fields should be flagged.
- Any service of type `LoadBalancer` or `NodePort` exposed outside the cluster should be reviewed.
- Ambient mesh / Istio policies: flag missing `AuthorizationPolicy` resources for workloads in the `dev` namespace.

## Supply chain

- External manifests fetched at runtime (e.g., `kubectl apply -f <url>`) should pin to a specific release URL, not `stable` or `latest`.
- Helm chart dependencies must have pinned versions in `Chart.yaml`.

## Argo CD

- Applications must not use `selfHeal: false` alongside `automated` sync without a clear comment explaining why.
- Source repos should always be explicit; parameterised `repoURL` values that can be influenced by untrusted input must be flagged.
