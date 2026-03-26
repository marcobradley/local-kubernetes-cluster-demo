## [0.0.0-development](https://github.com/marcobradley/local-kubernetes-cluster-demo/compare/v4.1.1...v0.0.0-development) (2026-03-26)

### ⚠ BREAKING CHANGES

* set the version to the major version v4
* created a single setup script for argocd
* corrected the paths
* reworked app of apps setup
* fixed meta-data for app
* updated bootstrap to make the dependency secret
* reworking the logic for argocd-core
* correcting circle logic issue with argocd
* integrating 1password
* only run helm lint against the api-demo
* removed the kind cluster lint path
* updated PR check
* separated out the values from the app config
* Implementing Grafana monitoring, removed kind cluster resources
* removed unusable actions
* fixing release
* fixed documentation
* update release changelog section
* updated the readme to detail the semantic versioning tool
* updated releaseme
* fixing semantic config to properly set the version
* add ingress for go api
* fixed missing file extention
* fixed yaml syntax errors
* fixed documentation
* fixed syntax errors
* updated PR check
* removed http
* renamed the argocd app
* renamed docker cluster to kind-cluster and updated the pull-request.yaml
* updated folder name and updated the pull-request.yaml
* renames the docker-desktop-cluster to kind-cluster
* broke out argocd into core and app
* creating k3d cluster
* moved the ignore file
* moved the ignore file
* update the helm structure

### Features

* add ingress for go api ([fed7ce5](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/fed7ce5a895f71de8e684f170f132a10c9f79b7e))
* adding csharp ui container ([7de97cf](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/7de97cfbfab964b7976d1af662c0238a18cbebc3))
* Adding envoy gateway ([5e24ebc](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/5e24ebc9f8d472f64122d9acc75745f280e89ce0))
* adding envoy proxy gateway settings ([c958c40](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/c958c40e713343a7da0021ec2197cf728073b1ba))
* adding go svc ([0d3fa7d](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0d3fa7db6a4c1ccdebf39c1a9227b6f4b8dccd73))
* adding istio ambient mode ([2d3694b](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/2d3694b61189c984228c9bba755ec8612a1d2074))
* adding kind cluster ([2bd9600](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/2bd960029d5332720c29443268140efeffd42396))
* adding new apis for csharp and ollama ([a628656](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/a628656579579ff354a4f271d2a05c074d066145))
* adding OAuth support ([3f86511](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/3f86511a7a0bf1514e6a1b18d822d1582d96fcc3))
* adding proxy for gateway ([c70d4c8](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/c70d4c847c1ed430434a85816f2e3ab7a41622be))
* adding rbac ([8ca781b](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/8ca781b80f2fe951ff033f354b784d782875b7cf))
* broke out argocd into core and app ([0028d16](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0028d16d5d1d2485f64f9b0eac8551589a717e62))
* creating k3d cluster ([1e4699a](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/1e4699ac52b09f195c0ce40e53515f00ff3f967a))
* expose deployment ([139fd52](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/139fd52f652a241ecd3fdc5bb8efc6db9f75eedd))
* fixed documentation ([6599b77](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/6599b776e47fdf3393c2cce02f793f9151abb3b1))
* fixed documentation ([75d8e1d](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/75d8e1d971bb703170d42c0d1a210429d105b135))
* fixed missing file extention ([5af96b4](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/5af96b43382c0564b4763a1a288077f95fe2c56f))
* fixed missing update ([a3a545a](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/a3a545a0187a07950d1b3b2db0028048deba9773))
* fixed syntax errors ([51367e9](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/51367e929cc0bc6bcac6babc7cfc16e36c700246))
* fixed yaml syntax errors ([43191b6](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/43191b61937a1354d87379093039f5f94844baad))
* fixing release ([dcf343e](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/dcf343e6dfd9499edde780a18a8cd37eac09baaf))
* fixing semantic config to properly set the version ([db94942](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/db94942357c4fa45025b0b472ea037c7c7fc3a31))
* Implementing Grafana monitoring, removed kind cluster resources ([3f0f969](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/3f0f969cd4f536cee89164de13b0e73519d04a57))
* integrating 1password ([c843c19](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/c843c198f923c2eb9a882fe9147549403c60d62f))
* only run helm lint against the api-demo ([1c6462f](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/1c6462f4e24eabbd4fe2d6a157cadfc7dccca570))
* removed http ([c47f40a](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/c47f40a9ecfde0f0401dbb22c0c94e35087e5059))
* removed the kind cluster lint path ([ead2626](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/ead2626ded13f7e2e2e0052c5048174b7a063f1b))
* removed unusable actions ([cfc9ff3](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/cfc9ff3cbd4b15bcc92f4e5d88b79bff7f91900b))
* renamed docker cluster to kind-cluster and updated the pull-request.yaml ([0b82d9a](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0b82d9a2fbfe687db47ffaf5e0c396c93a052bb2))
* renamed the argocd app ([93d8f94](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/93d8f94da2047cb36ef558b047f531faa3a2a333))
* renames the docker-desktop-cluster to kind-cluster ([a2b98d7](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/a2b98d703468f5a6388d81722089007a9dc96a70))
* reworking the cluster gateway ([23f29c3](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/23f29c363254df517c24756b68f227d7a1c1d2f8))
* separated out the values from the app config ([0608ee1](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0608ee1da204f1cbc79153842d72919e2ab3b00a))
* update release changelog section ([d629030](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/d629030a167c1b13b26273ed30b5071d62a7bd30))
* update target versions ([18b855e](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/18b855ecbcc53025db9ae7a029c2b19221db277a))
* updated documentation ([422d3b5](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/422d3b5177c3138eeed8595bf9a1290679c004f5))
* updated folder name and updated the pull-request.yaml ([937671e](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/937671eb6ac81253ec7e5ffc8da940cf78201413))
* updated PR check ([6838dc3](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/6838dc3e6fd69905eb61b235c1928fb60b88045a))
* updated PR check ([ccd35bd](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/ccd35bd0f39de964548b57a6f3ebde4a03bfebce))
* updated releaseme ([64552e0](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/64552e03d57fb379091b8f6bf1398c61322b4bdb))
* updated the readme to detail the semantic versioning tool ([97b7263](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/97b7263d782f2e04237168dcf89fc1c74bde56a7))

### Bug Fixes

* Add permissions for pull request workflow ([c084ea7](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/c084ea7d9eb3af47c9314a80f2956d957e732e6c))
* added override for the cniBinDir ([cb102d6](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/cb102d66cd439f0e55ef02c8c45d55788f1c15ad))
* adding a restore script to restore from a previous backup folder ([7d74a9b](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/7d74a9bee8dfe60646786a9155d84d6033d19375))
* adding a sync drift ignore for the istiod-default-validator ([01377ed](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/01377ede071bd289719b009aff2703b0299f2780))
* adding back missing secret missing secret ([266d9a8](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/266d9a8ab384c90d81fac7aa7c24be47a9635a4d))
* adding github actions workflow for release ([9d1ca79](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/9d1ca799d51ed648cdcd96cbcfad25d5915ef2ac))
* adding grafana to istio mesh ([49c536b](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/49c536b9b2e19804b136c637f011a261816cb89b))
* adding package.json ([0dbfd6e](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0dbfd6e06ccfce343beb67a0309159da8471a09a))
* adding permission ([f23b98f](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/f23b98f13f92ae59a2c10a4cfb91041c405e82f0))
* adding readme context ([0f00ed7](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0f00ed7ac0ccfa712fbed414983254f486af5bb0))
* Apply suggestions from code review ([3cc6c50](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/3cc6c50ff079281bab1300fd36df09260dfba247))
* Apply suggestions from code review ([e54d1c7](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/e54d1c7d67b0ad0526007777466765eac65c4a76))
* Change token for changelog pull request action ([0751f0d](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0751f0d2f67c2eabe9466efaf1996df7d2285ef6))
* correct the helm values location ([168014e](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/168014e55b938ea26203e25196548d9c7c6879fa))
* corrected NS of the route and updated the gateway to accept traffic ([ce585a4](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/ce585a436e57ad92ab03dceab7b530a7183bee31))
* corrected revision number ([ded1282](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/ded128270acf8546e79d579e65d09fade954d608))
* corrected the image path ([6c52957](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/6c5295742092da15ad6227400edfd20534c33492))
* corrected the paths ([0b0f1e1](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0b0f1e1c70a72a07be44ff6754728cb0fbad01f5))
* corrected the role bindings ([95d1696](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/95d169640cf21e6e58de7f967cdab58d129321f9))
* correcting circle logic issue with argocd ([bb2c035](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/bb2c035e426c7a6b5876f71c15da70c63a206c37))
* correcting grafana datasources ([1ddd3eb](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/1ddd3eba5b54c01ae33ea6809639519b2c1fbed8))
* correcting secrets for argocd ([5259960](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/52599609d4165b343ca34af61045fd28271b8035))
* correcting the helm structure ([a5e458b](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/a5e458b909fa15f23acdff3bce1376f3d7287e89))
* created a single setup script for argocd ([4c45cde](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/4c45cdeb5a4d8365f8b0f9a1cd742432fd4057a9))
* Fix UTF-8 encoding issue in deployment-go-api.yaml ([3b07814](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/3b078143775800d2394d23eceb0530f42917676d))
* fixed meta-data for app ([47137ac](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/47137ac30b61e32184330a9a7fcece0ae504bb27))
* fixed path ([317bf34](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/317bf34c0a75a8aebe781d52592fbe7a53f96b26))
* fixed path to charts ([3af26e1](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/3af26e138e83c7e08488386f9aeb5ad84177efa2))
* fixed path to use linux path structure ([78a20fb](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/78a20fb75f207f4aa6a68ae4f138a18d7c879dd5))
* fixing RBAC for oauth ([a490971](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/a4909712984152d04fea1389e3d5c30cf2a48e0e))
* hardened setup scripts to avoid race conditions and add checks ([eb02b4d](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/eb02b4d5ef82344f8af578db5a5f2763a5d1e324))
* incorrect syntax ([9917e9e](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/9917e9ec97aae2ef510260883b28d85f67e8eed1))
* minor updates to fix versioning and make istio an optional addon ([89bf06a](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/89bf06a2d12dc7d7437a2acf047bf0f7cca457c1))
* moved directories ([8de11f4](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/8de11f4f6e96a000820eda0bf796aa0e4d417d20))
* moved the helm charts unter a charts directory ([a3d2ac9](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/a3d2ac9a33838e0b71c94d4758cee6c61d4b1d1a))
* moved the ignore file ([a026194](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/a02619439fd91538396d2dd4def231b9507be743))
* moved the ignore file ([8583c01](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/8583c017ae4e027aee3b6cca8c99a9b559e06e3d))
* oauth ([5dae294](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/5dae294a1df38825ff57055ab550e719385f633c))
* reduce resources needed for the pods ([0f9f3a6](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0f9f3a63a36ce77c8d53a5ab42ff24b0f73e06b9))
* reducing the resource requirements for istio and grafana ([0b06e8a](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/0b06e8a017ae2badc443d37464b362fb4db576a1))
* remove localhost rule from argocd ingress to avoid route conflicts ([b181936](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/b18193606d1d2455e388b5ca8c8263c25ce43973))
* Removed extra ArgoCD application sources ([30aa6b7](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/30aa6b7f38a3857d46d6f71a705d0eabba387937))
* removed incorrect ambient labeling ([44ea69b](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/44ea69bf0a739f202463fe306fe7cf96b344695b))
* removed nodejs ([1a88ce3](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/1a88ce3303154bf8034166a32f4e74d1fb6ac846))
* removed org for local ([f59c970](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/f59c97079e9dcc4ab9a0d62b87735e9a3423f495))
* removed tls requirement for local prometheus operator ([279ee22](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/279ee22076cafec32590865d48646939ec9cdc4e))
* removed unused template ([40ab598](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/40ab598e6c17f66838e7269e7fe999e22fb02492))
* reworked app of apps setup ([cea89c1](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/cea89c107d191d09450cac4f1773e684c2b11597))
* reworking the logic for argocd-core ([b4a29e2](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/b4a29e233b0a82efcd6d1dd576fe0ac6136c85f6))
* set gateway type to NodePort and point to the port 30000 ([2db61a0](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/2db61a016f9c97bdc8ab1adee428e254711f1ee3))
* set monitoring to use the v4 major version ([7cd697e](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/7cd697ec57bfe749b98c4ace404884cb8164b710))
* set the version to the major version v4 ([bb75bb6](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/bb75bb612dd5a421b6555b57a044577da9f6386f))
* set up the templates correctly ([1c69883](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/1c698836c89b01449cd6f9c4372df24435318bfb))
* update action ([9a6b369](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/9a6b369d1cb6cd6cc1a51c93513459df320ad4fe))
* update app to autofind files under directory ([37d0968](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/37d0968d6b7ae33050cd89b3e687371bd6ba310e))
* update helm to just use inline values ([3a84d7e](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/3a84d7ea465de834f03559ed189884b50ff2e40e))
* update README and rename kind config file ([159fe0e](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/159fe0ec4b62d90aea2ce74ed72a8652c965638d))
* update service type to nodeport ([73e59a9](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/73e59a9a03602b5cb4772903e6f477c20d7b3876))
* update the helm structure ([2716694](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/27166945538f22f062687c85a8f8879e70ce1cf4))
* updated api helm chart ([878b12c](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/878b12cb27eec29c8e86bb1534de22d22e1aaa2c))
* updated bootstrap to make the dependency secret ([cdd89c6](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/cdd89c65e87033b19c55c169680cfd15218bc925))
* updated permissions ([fce814b](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/fce814bcd8921ac44545272fbd6aad539cde1af6))
* updated port for ui service ([253ecbc](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/253ecbcdc338aef81c7eaae1482d3defec1b72e8))
* updated repos for go and csharp apis, updated the workload rbac values files ([ff495e4](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/ff495e459f452c864d02623b6ed6b2c35648336b))
* updated target port for csharp adding a secret to the cluster for the ssh key ([f1e5eab](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/f1e5eab6a72a2a24d48af3a58fb2809ecbb9ece2))
* updated the name of the deployment ([f119359](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/f119359ef641034ce2d008fb7d18c1b478de71b2))
* updated the port ([8ab9673](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/8ab9673240719cdae5bd4bce5494b9662d01ac23))
* updated url to use ssh ([2a8a4d4](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/2a8a4d4855ffbc287417fb34a4b4c4aa0e0058f8))
* use branches for now ([749a93c](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/749a93c3d8be2cbda79c0a10bba4a5c1233074e7))
* version v4 tag doesn't exist ([a2b31fa](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/a2b31fac66e0df00236a4e1b8e6c8acc255727f5))

## [0.1.0](https://github.com/marcobradley/local-kubernetes-cluster-demo/compare/v0.0.2...v0.1.0) (2026-02-20)

### Features

* create nginx pod ([f7ac633](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/f7ac63306e592a09a5505f44f91e2959fc20248a))

## [0.0.2](https://github.com/marcobradley/local-kubernetes-cluster-demo/compare/v0.0.1...v0.0.2) (2026-02-20)

### Bug Fixes

* updated repo url ([433892a](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/433892a5589c60da0f4f5b7c9d2a51be87e1c887))

## [0.0.1](https://github.com/marcobradley/local-kubernetes-cluster-demo/compare/67fe23b5f1261bc9a40126250ae53bd960331ff5...v0.0.1) (2026-02-19)

### Features

* initall setup ([67fe23b](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/67fe23b5f1261bc9a40126250ae53bd960331ff5))

### Bug Fixes

* updated app configs ([bd750c3](https://github.com/marcobradley/local-kubernetes-cluster-demo/commit/bd750c38ed68cf50b185f06e2ea81bd0f19e64aa))
