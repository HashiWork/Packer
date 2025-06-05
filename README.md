# 🐧 Génération automatisée d’un Template Debian 12 avec Packer & Proxmox

Ce projet a pour objectif de créer un **template Debian 12** entièrement automatisé pour une plateforme **Proxmox VE**, en utilisant **Packer** et un fichier **Preseed**. Ce template permet d’accélérer les déploiements de VM homogènes et prêtes à l’emploi.

---

## 📝 Description

Ce TP met en œuvre :

* **Packer** en syntaxe HCL2 pour décrire une image de machine Debian 12
* Une **installation non-interactive** de Debian via un fichier `preseed.cfg`
* Le déploiement sur un **hyperviseur Proxmox** via le plugin `proxmox-iso`
* L’utilisation de variables pour une configuration flexible et sécurisée

Le résultat est une **VM Debian 12 prête à être convertie en template**, avec :

* Un utilisateur `mco` avec droits sudo sans mot de passe
* L’agent QEMU installé pour intégration avec Proxmox
* Une configuration clavier/langue FR et partitionnement LVM automatique

---

## 🎯 Objectifs pédagogiques / techniques

* [x] Automatiser le déploiement d’une VM avec Packer
* [x] Créer un template Debian 12 propre et minimal
* [x] Utiliser Preseed pour automatiser l’installation
* [x] Gérer la configuration réseau, disque, CPU, mémoire, utilisateur SSH…
* [x] Respecter les bonnes pratiques de configuration système

---

## 🧰 Technologies utilisées

| Outil             | Description                             |
| ----------------- | --------------------------------------- |
| **Packer**        | Génération d'image VM automatisée       |
| **Proxmox VE**    | Hyperviseur de virtualisation cible     |
| **Debian 12 ISO** | OS à installer                          |
| **Preseed**       | Automatisation de l’installation Debian |

---

## 🗂️ Arborescence du projet

```bash
.
├── debian12.pkr.hcl            # Configuration Packer (builder, variables, disques, réseau)
├── customdeb12.pkrvars.hcl     # Valeurs spécifiques à ton environnement Proxmox
├── preseed.cfg                 # Script d'installation Debian automatisée (langue, user, sudo, disques)
└── README.md
```

---

## 🔍 Description des fichiers

### `debian12.pkr.hcl`

Ce fichier est le **fichier principal de configuration Packer**. Il contient :

* Le bloc `packer.required_plugins` pour déclarer le plugin `proxmox`
* Toutes les **variables déclarées** (BIOS, disque, réseau, utilisateur, stockage…)
* Le bloc `source "proxmox-iso"` qui décrit la **configuration du build** Proxmox

  * Types de disque (scsi, raw, 20G)
  * CPU (`nb_core`, `nb_cpu`), RAM (`nb_ram`)
  * Réseau virtio sur `vmbr0`
  * ISO fourni par le stockage `local:iso`
  * Activation de l’agent QEMU
  * Utilisation du fichier `preseed.cfg` via `boot_command`
* Le bloc `build` pour exécuter ce source

### `customdeb12.pkrvars.hcl`

Ce fichier contient les **valeurs concrètes** des variables définies dans `debian12.pkr.hcl` :

* `api_username` et `api_password` pour accéder à l’API de Proxmox (à ne jamais publier)
* `ssh_username` et `ssh_password` créés via Preseed (utilisateur mco)
* `iso_file` vers `local:iso/debian-12amd64.iso`
* `bios_type = seabios`, `cpu_type = x86-64-v2-AES`, `machine_default_type = q35`
* `nb_core = 2`, `nb_cpu = 2`, `nb_ram = 4096`, `disk_size = 20G`, `disk_format = raw`
* `bridge_name = vmbr0`, `network_model = virtio`, `qemu_agent_activation = true`
* `ssh_timeout = "35m"` pour laisser le temps à Debian de s’installer tranquillement

### `preseed.cfg`

Ce fichier permet une **installation silencieuse et complète** de Debian 12 :

* Langue : FR, Clavier : FR-latin9, Fuseau : Europe/Paris
* Installation via miroir officiel (`deb.debian.org`, sans proxy)
* Partitionnement LVM automatique sur `/dev/sda`
* Création de l’utilisateur `mco` avec mot de passe `***`
* Mot de passe root activé localement (`***`) — à désactiver ensuite en prod
* Installation de paquets : `openssh-server`, `qemu-guest-agent`, `cloud-init`, `sudo`, etc.
* Activation automatique de `sudo` sans mot de passe pour l’utilisateur `mco`

---

## 🚀 Instructions de build

```bash
packer init .
packer validate -var-file=customdeb12.pkrvars.hcl debian12.pkr.hcl
packer build -var-file=customdeb12.pkrvars.hcl debian12.pkr.hcl
```
https://www.youtube.com/watch?v=WDG5cT9qA_o
