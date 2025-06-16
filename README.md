# 💻 Mateus Gomes - Rails Coding Challenge

Este é um projeto de desafio técnico desenvolvido em **Ruby on Rails 5.2.6** com foco em APIs, testes automatizados e ambiente Dockerizado.

---

## ✨ Funcionalidades

- ✅ Filtro de usuários por empresa, nome, e-mail e username (com busca parcial)
- ✅ Confirmação de conta via e-mail (usando `letter_opener`)
- ✅ CRUD completo de empresas com HTML (ERB)
- ✅ Listagem de tweets com paginação tipo cursor (infinite scroll)
- ✅ Testes com RSpec, FactoryBot e seeds automatizados
- ✅ Ambiente Docker completo com Rake task de setup e testes

---

## 🚀 Como rodar o projeto (Docker)

### 1. Clone o repositório

```bash
git clone git@github.com:MateusGomes04/mateus-gomes.git
cd mateus-gomes
```

Ou com HTTPS:

```bash
git clone https://github.com/MateusGomes04/mateus-gomes.git
cd mateus-gomes
```

---

### 2. Suba a aplicação com Docker

```bash
docker-compose up web
```

Este comando irá:

- Instalar dependências com `bundle install`
- Rodar o setup completo (`rake app:setup`)
- Inicializar o servidor em `http://localhost:3000`

---

## 🧪 Rodar os testes manualmente

```bash
docker-compose run web bundle exec rspec
```

---

## 🛠️ Task personalizada de setup (`rake app:setup`)

Executa o seguinte:

- Para `development`: `db:drop`, `db:create`, `db:migrate`, `db:seed`
- Para `test`: `db:drop`, `db:create`, `db:migrate`

Pode ser executada a qualquer momento:

```bash
docker-compose run web bundle exec rake app:setup
```

---

## 🐳 Estrutura Docker

- `Dockerfile`: define imagem com Ruby 2.7.6
- `docker-compose.yml`: orquestra o serviço principal
- `entrypoint.sh`: script que executa o setup e (opcionalmente) os testes
- `tmp/.app_setup_done`: usado para evitar múltiplos setups no mesmo container

---

## 🔎 Exemplo de filtro por username com _partial match_

Busca por `"ma"` retorna:

- `username_1: max`
- `username_2: mathew`

A busca considera insensibilidade a maiúsculas e minúsculas.

---

## 🗂️ Organização do projeto

- `app/models/user.rb`: contém os scopes usados nos filtros
- `app/services/user_filter_service.rb`: serviço para aplicar os filtros recebidos
- `spec/`: testes automatizados com RSpec
- `lib/tasks/app.rake`: Rake task de setup de banco
- `app/views/companies/`: páginas HTML ERB para CRUD de empresas

---

## 💌 Confirmação de conta

Simulada com `letter_opener` (ambiente de desenvolvimento). Ao criar um novo usuário, um e-mail é enviado para confirmar a conta.

---

## 👨‍💻 Autor

Feito com dedicação por **[Mateus Gomes](https://github.com/MateusGomes04)**.

---

## 📜 Licença

Este projeto é apenas para fins de avaliação técnica.
