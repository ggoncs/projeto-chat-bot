# DevSecOps: Chatbot UI On-Premise Deployment (Proxmox VE + K3s)

Este repositório contém a Infraestrutura como Código (IaC) e a esteira de Integração e Entrega Contínuas (CI/CD) para a implantação de uma interface de Chatbot. O escopo principal deste projeto é a adaptação de uma arquitetura cloud-native baseada na AWS para um ambiente on-premise, utilizando Proxmox VE e K3s.

## O Valor Educacional: Transição da AWS para Proxmox

A migração de uma stack da AWS para um ambiente virtualizado local é um exercício prático focado na engenharia de infraestrutura e DevOps. Em provedores de nuvem, os serviços gerenciados abstraem a complexidade das redes, do balanceamento de carga e do provisionamento de nós. Ao internalizar essa arquitetura no Proxmox, o projeto força a compreensão dos mecanismos subjacentes que sustentam a infraestrutura distribuída.

| Componente Cloud (AWS) | Alternativa Local (Proxmox VE) | Fundamento Técnico Abordado |
| :--- | :--- | :--- |
| AWS EC2 / EKS | K3s em VM Ubuntu | Provisionamento de sistema operacional via Cloud-Init e administração do Control Plane do Kubernetes sem a automação do provedor de nuvem. |
| AWS Classic ELB / ALB | MetalLB | Configuração de redes Layer 2, anúncios ARP e roteamento de tráfego de entrada para pods em um cluster bare-metal. |
| AWS Secrets Manager | Kubernetes Native Secrets | Gerenciamento de estado de segredos codificados em Base64 e injeção em contêineres através de variáveis de ambiente. |
| AWS ECR | Docker Hub | Autenticação remota em registros de imagem e gerenciamento de credenciais na pipeline de CI/CD. |
| Terraform (AWS Provider) | Terraform (BPG Proxmox) | Integração com APIs de hypervisors on-premise, alocação de discos SCSI virtuais e gestão de certificados SSL internos. |

## Segurança Reforçada: GitHub Actions Self-Hosted Runner

A automação deste projeto substitui o Jenkins por um Self-Hosted Runner do GitHub rodando dentro da rede local. Como agentes locais apresentam vetores de ataque para execução remota de código (RCE) e movimentação lateral, a segurança da esteira foi implementada com as seguintes diretrizes restritivas:

* Execução Efêmera (--ephemeral): O agente de execução processa estritamente um único job e é finalizado pelo serviço logo em seguida. Isso garante que caches maliciosos, credenciais residuais ou alterações no sistema de arquivos não persistam entre execuções.
* Isolamento de Privilégios (Least Privilege): O runner é operado sob um usuário Linux dedicado, sem privilégios administrativos (sem acesso de sudo), mitigando o risco de escalonamento de privilégios caso um contêiner sofra bypass.
* Workflow Hardening:
    * Permissões Estritas: O escopo do GITHUB_TOKEN no workflow é limitado explicitamente à permissão de leitura (permissions: contents: read).
    * Pinagem por SHA: O consumo de Actions de terceiros no arquivo de deploy utiliza hashes SHA imutáveis (ex: uses: actions/checkout@b4ffde65f4...) em vez de tags de versão (ex: @v3), prevenindo ataques à cadeia de suprimentos (Supply Chain Attacks).
* Restrição de Forks: O repositório e o runner estão configurados para exigir aprovação manual antes de executar qualquer código proveniente de Pull Requests externos.

### Baseado no projeto: https://github.com/DevCloudNinjas/DevOps-Projects/tree/master/project-28-openai-chatbot-eks
