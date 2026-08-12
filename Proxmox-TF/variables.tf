variable "proxmox_api_url" {
  type        = string
  description = "URL da API do Proxmox VE (ex: https://192.168.1.100:8006/api2/json)"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "ID do API Token do Proxmox (ex: root@pam!terraform_token)"
  sensitive   = true
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "Secret do API Token gerado no Proxmox"
  sensitive   = true
}

variable "target_node" {
  type        = string
  description = "Nome do nó do Proxmox onde a VM será criada"
  default     = "pve"
}

variable "vm_name" {
  type        = string
  description = "Nome da VM no Proxmox"
  default     = "k3s-all-in-one"
}

variable "vm_id" {
  type        = number
  description = "ID numérico da VM"
  default     = 200
}

variable "template_vm_id" {
  description = "ID do template"
  default     = "9501"
}

variable "storage_name" {
  type        = string
  description = "Storage do Proxmox onde o disco será alocado"
  default     = "local-lvm"
}

variable "ssh_public_key" {
  type        = string
  description = "Sua chave pública SSH para acessar a VM criada"
}
