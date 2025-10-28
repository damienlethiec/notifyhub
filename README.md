# NotifyHub - Application d'Entretien Technique

> Système de notifications entre organisations gouvernementales

---

## 🎯 Contexte

Bienvenue ! Cette application sera le support de notre entretien technique.

**NotifyHub** est une API Rails simplifiée qui permet à des organisations gouvernementales d'échanger des notifications. L'application fonctionne, mais contient des points d'amélioration que nous explorerons ensemble lors de l'entretien.

**Important** : Ceci est un exercice de pair programming. L'objectif n'est pas de tout résoudre parfaitement, mais plutôt d'observer votre approche, votre raisonnement et comment nous collaborons.

---

## 📋 Prérequis

- Ruby 3.4.7
- Rails 8.1.0
- PostgreSQL 16+
- Bundler

---

## 🚀 Installation

### 1. Cloner le dépôt

```bash
git clone <repo-url>
cd notifyhub
```

### 2. Installer les dépendances

```bash
bundle install
```

### 3. Configurer la base de données

```bash
# Créer les bases (development et test)
rails db:create

# Exécuter les migrations
rails db:migrate

# Charger les données de test
rails db:seed
```

### 4. Lancer l'application

```bash
rails server
```

L'API sera accessible sur `http://localhost:3000`

---

## 🧪 Tests

```bash
# Exécuter tous les tests
bundle exec rspec

# Tests avec coverage
bundle exec rspec --format documentation
```

---

## 🔐 Authentification

L'API utilise JWT pour l'authentification.

### Obtenir un token

```bash
curl -X POST http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "alice@interieur.gouv.fr",
    "password": "password"
  }'
```

**Réponse** :
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "email": "alice@interieur.gouv.fr",
    "organization_id": 1,
    "role": "admin"
  }
}
```

### Utiliser le token

```bash
curl http://localhost:3000/api/v1/notifications \
  -H "Authorization: Bearer <votre-token>"
```

---

## 👥 Comptes de Test

| Email                          | Password   | Organisation            | Rôle  |
|--------------------------------|------------|-------------------------|-------|
| alice@interieur.gouv.fr        | password   | Ministère de l'Intérieur | Admin |
| bob@interieur.gouv.fr          | password   | Ministère de l'Intérieur | User  |
| charlie@justice.gouv.fr        | password   | Ministère de la Justice  | Admin |
| diane@justice.gouv.fr          | password   | Ministère de la Justice  | User  |

---

## 📡 Endpoints API

### Authentification

#### `POST /api/v1/login` - Connexion (**pas d'authentification requise**)

```bash
curl -X POST http://localhost:3000/api/v1/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "alice@interieur.gouv.fr",
    "password": "password"
  }'
```

### Organizations

#### `GET /api/v1/organizations` - Liste des organisations (**pas d'authentification requise**)

```bash
curl -X GET http://localhost:3000/api/v1/organizations \
  -H "Content-Type: application/json"
```

#### `GET /api/v1/organizations/:id` - Détails d'une organisation (**pas d'authentification requise**)

```bash
curl -X GET http://localhost:3000/api/v1/organizations/1 \
  -H "Content-Type: application/json"
```

### Notifications

#### `GET /api/v1/notifications` - Liste des notifications (**authentification requise**)

```bash
TOKEN="votre-token-jwt"

curl -X GET http://localhost:3000/api/v1/notifications \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"
```

#### `GET /api/v1/notifications/:id` - Détails d'une notification (**authentification requise**)

```bash
TOKEN="votre-token-jwt"

curl -X GET http://localhost:3000/api/v1/notifications/1 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"
```

#### `POST /api/v1/notifications` - Créer une notification (**authentification requise**)

```bash
TOKEN="votre-token-jwt"

curl -X POST http://localhost:3000/api/v1/notifications \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "notification": {
      "title": "Nouvelle notification",
      "body": "Contenu de la notification",
      "to_organization_id": 2,
      "priority": "normal"
    }
  }'
```

#### ~~`POST /api/v1/notifications/:id/mark_as_read`~~ - **À implémenter (Exercice 4)**

---

## 🗄️ Modèle de Données

### Organization
- `name` : string
- `siret` : string (unique)

### User
- `email` : string (unique)
- `password_digest` : string
- `organization_id` : references
- `role` : integer (0: user, 1: admin)

### Notification
- `from_organization_id` : references
- `to_organization_id` : references
- `title` : string
- `body` : text
- `status` : string (pending, sent, read)
- `priority` : string (low, normal, high, urgent)
- `attachment` : Active Storage (optionnel)

---

## 📚 Stack Technique

- **Framework** : Rails 8.1.0 (API mode)
- **Database** : PostgreSQL 16+
- **Queue** : Solid Queue
- **Cache** : Solid Cache
- **Authentication** : JWT
- **Authorization** : Pundit
- **Views** : Jbuilder
- **Tests** : RSpec + FactoryBot + Shoulda Matchers
- **Linting** : StandardRB
- **N+1 Detection** : Bullet (configuré pour development et test)

---

## 🧰 Commandes Utiles

```bash
# Console Rails
rails console

# Routes
rails routes

# Linting
bundle exec standardrb

# Migrations
rails db:migrate
rails db:rollback

# Reset database
rails db:reset

# Background jobs (Solid Queue)
bin/jobs
```

---

## 🔍 Détection des Problèmes N+1 avec Bullet

Bullet est configuré pour détecter automatiquement les problèmes de N+1 queries :
- En **développement** : warnings dans la console Rails et dans `log/bullet.log`
- En **test** : lève une erreur si un N+1 est détecté

---

## 🐛 Notes pour l'Entretien

Cette application contient des points d'amélioration volontaires que nous explorerons ensemble :

### Exercice 1 : Performance
L'endpoint de liste des notifications a des problèmes de performance (N+1 queries, pas de pagination).

**Endpoint concerné** :
- `GET /api/v1/notifications` (index)

### Exercice 2 : Sécurité & Authorization
Un utilisateur peut accéder à des notifications qui ne lui sont pas destinées.

**Endpoint concerné** : `GET /api/v1/notifications/:id`

### Exercice 3 : Architecture & Refactoring
La logique métier pour la création de notifications est dans le controller.

**Endpoint concerné** : `POST /api/v1/notifications`

### Exercice 4 : Nouvelle Fonctionnalité (TDD)
Implémenter l'endpoint `POST /api/v1/notifications/:id/mark_as_read` pour permettre de marquer une notification comme lue.

---

## 📞 Support

En cas de problème lors de l'installation :

1. Vérifiez les versions Ruby/Rails/PostgreSQL
2. Vérifiez que PostgreSQL est démarré
3. Vérifiez les logs : `tail -f log/development.log`

---

## 📄 Licence

Application de démonstration pour entretiens techniques - Usage interne uniquement
