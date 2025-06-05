# TP Ansible & Terraform

## 🚀 Introduction

Ce projet consiste à déployer une infrastructure cloud avec Terraform et à configurer les serveurs avec Ansible.

### 🌐 Objectifs :

* Utiliser Terraform pour créer des instances EC2 sur AWS.
* Utiliser Ansible (via WSL) pour configurer les serveurs de manière automatisée.

---

## ✅ Prérequis

* Un compte AWS avec des identifiants de connexion (Access Key et Secret Access Key).
* Terraform installé sur votre machine.
* AWS CLI installé et configuré.
* WSL (Windows Subsystem for Linux) avec Ansible installé.

---

## ✅ Configuration de l'Environnement

### 1. Configuration d'AWS

```bash
aws configure
```

* Lors de la configuration :

  * **AWS Access Key ID** : Entrez la clé d'accès.
  * **AWS Secret Access Key** : Entrez la clé secrète.
  * **Default region name** : `eu-north-1`.
  * **Default output format** : `json`.

* Région définie sur : `eu-north-1`.

### 2. Initialisation de Terraform

```bash
terraform.exe -v  # Vérification de la version
terraform.exe init
terraform.exe validate
```

---

## ✅ Déploiement de l'Infrastructure

### 1. Application de la Configuration Terraform

```bash
terraform.exe apply
```

* Création de trois instances EC2 :

  * `FCS-Frontend`
  * `FCS-Backend`
  * `FCS-Database`
* Génération de la clé SSH : `terraform_ec2_key`.

### 2. Configuration des Règles de Sécurité AWS

* Modification des règles de sécurité AWS pour autoriser les flux SSH (port 22) sur les instances.

### 3. Connexion SSH aux Instances

```bash
ssh -i terraform_ec2_key ec2-user@<IP_INSTANCE>
```

---

## ✅ Configuration avec Ansible (via WSL)

### 1. Installation d'Ansible

```bash
sudo apt update && sudo apt install ansible -y
```

### 2. Configuration de l'Inventaire Ansible (`inventory.yml`)

```yaml
fcs:
  children:
    webservers:
      hosts:
        frontend:
          ansible_host: <IP_Frontend>
        backend:
          ansible_host: <IP_Backend>
    databases:
      hosts:
        database:
          ansible_host: <IP_Database>
  vars:
    ansible_user: ec2-user
    ansible_python_interpreter: /usr/bin/python3.9
```

### 3. Vérification de la Connectivité

```bash
ansible fcs -m ping -i inventory.yml --private-key terraform_ec2_key
```

---

## ✅ Configuration avec Ansible (Playbooks)

### 1. Installation de MongoDB 8.0 (Database)

* Playbook : `mongodb_setup.yml`
* Commande :

```bash
ansible-playbook mongodb_setup.yml -i inventory.yml --private-key terraform_ec2_key
```

### 2. Installation de Node.js (Backend)

* Playbook : `node.yml`
* Commande :

```bash
ansible-playbook node.yml -i inventory.yml --private-key terraform_ec2_key
```

### 3. Installation de Nginx (Frontend)

* Playbook : `nginx.yml`
* Commande :

```bash
ansible-playbook nginx.yml -i inventory.yml --private-key terraform_ec2_key
```

### ⚠️ Problème Étape 10 :

* Impossible d'accéder au dépôt GitHub de l'application (404 Not Found).
* Blocage sur cette étape.

---

## ✅ Gestion de la Sécurité AWS

* Utilisation de la clé SSH générée par Terraform (`terraform_ec2_key`).
* Configuration des règles de sécurité pour les ports SSH.

---

## ✅ Destruction de l'Infrastructure

```bash
terraform.exe destroy
```

* Les ressources sont détruites proprement.
