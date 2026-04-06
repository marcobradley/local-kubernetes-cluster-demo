---
description: "Use when creating or editing Kubernetes, Helm, and Argo CD YAML in this repo. Enforces manifest syntax consistency and cluster security controls (RBAC least privilege, pinned image tags, securityContext, ingress exposure, and secret handling)."
name: "Cluster Syntax And Security"
applyTo:
  - "**/*.yaml"
  - "**/*.yml"
---
# Cluster Syntax And Security Rules

## Scope

Apply these rules to YAML/YML manifests in this workspace, with strongest relevance to cluster manifests under k3d-cluster, including Helm templates and Argo CD applications.

## YAML and Kubernetes Syntax

- Keep standard key order at top level: apiVersion, kind, metadata, spec.
- Ensure metadata.name and metadata.namespace are explicit when resource type is namespaced.
- Keep selectors and pod labels aligned exactly for Deployments and Services.
- Use valid Helm templating syntax and avoid mixed indentation; keep two-space YAML indentation.
- Prefer one resource per file unless the chart pattern already uses multi-document YAML.
- Keep Argo CD Application finalizer: resources-finalizer.argocd.argoproj.io (or background variant already used in this repo).
- Use pinned chart versions in Argo CD Application spec.source.targetRevision for external charts.

## Secrets and Credential Handling

- Never hardcode secrets, API keys, tokens, or passwords in manifests, values files, or scripts.
- Use External Secrets Operator and 1Password Connect for secret material.
- Do not introduce direct kubectl secret creation commands from literals or files, except existing approved flow in scripts/set-1password-connect-secrets.ps1.
- Never log or echo secret values.

## RBAC Least Privilege

- Disallow wildcards in RBAC unless there is explicit, inline justification:
  - apiGroups: ["*"]
  - resources: ["*"]
  - verbs: ["*"]
- Prefer Role and RoleBinding in namespace scope over ClusterRole and ClusterRoleBinding.
- Never grant cluster-admin to workload service accounts.

## Container and Image Security

- Do not use image tag latest. Require immutable tag or digest.
- Strongly prefer container securityContext defaults. If not set, include a short rationale in comments or PR notes:
  - allowPrivilegeEscalation: false
  - readOnlyRootFilesystem: true
  - runAsNonRoot: true
- Prefer explicit runAsUser and runAsGroup when compatible with the image.

## Network Exposure and Mesh Policy

- Do not use wildcard ingress hosts.
- Any LoadBalancer or NodePort service requires a short risk note in the manifest comments.
- For workloads in dev namespace using Istio ambient mesh, ensure an AuthorizationPolicy exists or is updated with least-privilege rules.

## Validation Checklist For Changes

When proposing YAML changes, verify and call out:

- Resource passes schema and indentation sanity checks.
- Images are pinned and not latest.
- RBAC contains no wildcard permissions.
- Workloads include securityContext hardening.
- Secret flow uses 1Password Connect and External Secrets.
- Ingress exposure is host-specific and intentional.
