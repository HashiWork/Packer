
---

## 📁 Détails des fichiers

### `debian12.pkr.hcl`

Ce fichier contient :

- La déclaration du plugin `proxmox`
- La définition de toutes les **variables globales** utilisées pour le build
- Le bloc `source "proxmox-iso"` pour décrire la VM à créer :
  - ISO Debian
  - Stockage, CPU, RAM, disque
  - Agent QEMU, interface réseau VirtIO
  - Utilisation d’un fichier `preseed.cfg` via le `boot_command`
  - Accès API au cluster Proxmox
- Un bloc `build` avec :
  - L’appel au source
  - Un bloc `provisioner "shell"` avec tous les paquets à installer en post-install :
    - Nginx
    - Docker Engine + CLI + Compose plugin
    - Node.js (via le dépôt NodeSource)
    - MongoDB Community Edition 8.0

### `customdeb12.pkrvars.hcl`

Ce fichier contient les **valeurs spécifiques** à ton environnement Proxmox :

- Adresse de l’API, nom du nœud (`proxmox-tuds`)
- Nom, ID, description de la VM
- Ressources : CPU, RAM, disque
- Identifiants de connexion pour SSH et API
- Paramètres du réseau (bridge, modèle, cloud-init)

> 💡 Ce fichier est **hors du repo GitHub** pour éviter de publier des identifiants sensibles.

### `preseed.cfg`

Automatise l’installation de Debian :

- Langue FR, clavier français, fuseau Europe/Paris
- Miroir Debian sans proxy
- LVM automatique sans chiffrement
- Utilisateur `mco` avec droits sudo sans mot de passe
- Installation de base : `openssh-server`, `sudo`, `cloud-init`, `qemu-guest-agent`
- Activation directe du compte root avec mot de passe
- Ajout du groupe `sudo` à l’utilisateur et création du fichier dans `/etc/sudoers.d/`

---

## 🔧 Provisioning post-install (Packer)

Une fois Debian installé et accessible en SSH, **Packer exécute un script shell** intégré en fin de `debian12.pkr.hcl`. Ce script :

1. Met à jour les paquets
2. Installe `nginx`
3. Installe Docker (apt repo officiel)
4. Installe Node.js (via `deb.nodesource.com`)
5. Installe MongoDB (via `repo.mongodb.org`)

Le script est exécuté avec `sudo` car l'utilisateur `mco` a les droits nécessaires (donnés via le `preseed.cfg`).

---

## 🚀 Lancer le build

```bash
# Initialiser les plugins
packer init .

# Vérifier la validité de la config
packer validate -var-file=customdeb12.pkrvars.hcl debian12.pkr.hcl

# Lancer le build complet
packer build -force -var-file=customdeb12.pkrvars.hcl debian12.pkr.hcl
```
---

## 📺 Démonstration vidéo (POC)

Tu peux voir l'exécution complète et le résultat de ce TP dans cette vidéo :

▶️ [POC disponible sur YouTube](https://www.youtube.com/watch?v=okomPzQzrWY)

---
## 👨‍💻 Auteur

TP réalisé par **Samuel S.** dans le cadre d’un projet de virtualisation automatisée sur **Proxmox** avec **Packer** et **Debian 12**.

