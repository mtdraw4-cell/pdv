# 🟢🟡 Mechama PDV

> **O PDV do povo brasileiro** - Sistema PDV + ERP gratuito para microempreendedores (MEI, informais, lojinhas, ambulantes, feirantes)

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](docker-compose.yml)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104+-009688.svg)](https://fastapi.tiangolo.com)
[![React](https://img.shields.io/badge/React-18+-61DAFB.svg)](https://reactjs.org)

![Mechama PDV Banner](https://via.placeholder.com/800x200/009C3B/FFFFFF?text=Mechama+PDV)

## 📋 Sumário

- [Sobre](#sobre)
- [Funcionalidades](#funcionalidades)
- [Tecnologias](#tecnologias)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Uso](#uso)
- [API](#api)
- [Contribuição](#contribuição)
- [Licença](#licença)

## 🎯 Sobre

O **Mechama PDV** é um sistema de ponto de venda (PDV) e gestão empresarial (ERP) desenvolvido especificamente para atender às necessidades dos microempreendedores brasileiros.

### 💚 Missão Social

- **100% gratuito** para quem faz até 100 vendas/mês
- **Código aberto** - transparente e auditável
- **Sem burocracia fiscal** - NF-e opcional, recibo simples por padrão
- **Sustentado por doações** - quem pode ajuda, quem precisa usa de graça

### 🎯 Público-Alvo

- MEI (Microempreendedor Individual)
- Comerciantes informais
- Donos de lojinhas de bairro
- Ambulantes e feirantes
- Salões de beleza e barbearias
- Pequenos restaurantes e lanchonetes
- Deliverys de pequeno porte

## ✨ Funcionalidades

### 🛒 Módulo PDV

- ✅ **Venda touchscreen** - interface rápida e intuitiva
- ✅ **Busca por código/nome/foto** - encontre produtos em segundos
- ✅ **Categorias e favoritos** - organize seu catálogo
- ✅ **Múltiplos modos**: balcão, mesas, delivery, self-service, ambulante
- ✅ **Múltiplas formas de pagamento**: dinheiro, Pix, cartão, fiado
- ✅ **Descontos e acréscimos** - flexibilidade na venda

### 💬 WhatsApp Integrado

- ✅ **Envio de comprovantes** - automático após venda
- ✅ **Catálogo digital** - envie produtos para clientes
- ✅ **Cobranças** - lembre clientes de dívidas
- ✅ **Evolution API** - integração open-source gratuita

### 💳 Pix QR Code

- ✅ **QR Code dinâmico** - geração automática via Mercado Pago
- ✅ **Copia e cola** - para quem prefere
- ✅ **Confirmação automática** - via webhook
- ✅ **Pix estático** - use sua chave Pix diretamente

### 📊 Gestão

- ✅ **Estoque simples** - controle de entrada e saída
- ✅ **Clientes e fiado** - histórico de compras e limites
- ✅ **Caixa diário** - abertura, fechamento e movimentações
- ✅ **Relatórios** - vendas, produtos mais vendidos, lucros
- ✅ **Dashboard motivador** - acompanhe seu crescimento

### 🔒 Segurança e Privacidade

- ✅ **Dados isolados** - multi-tenant por empresa
- ✅ **Backup automático** - seus dados protegidos
- ✅ **Sem venda de dados** - privacidade garantida
- ✅ **Código aberto** - você pode auditar tudo

## 🛠 Tecnologias

### Backend
- **Python 3.11+** - Linguagem principal
- **FastAPI** - Framework web moderno e rápido
- **SQLAlchemy 2.0** - ORM para banco de dados
- **PostgreSQL 15** - Banco de dados relacional
- **Redis** - Cache e filas
- **Pydantic** - Validação de dados

### Frontend
- **React 18+** - Biblioteca UI
- **TypeScript** - Tipagem estática
- **Vite** - Build tool rápido
- **Tailwind CSS** - Estilos utilitários
- **shadcn/ui** - Componentes modernos
- **Zustand** - Gerenciamento de estado

### Infraestrutura
- **Docker** - Containerização
- **Nginx** - Proxy reverso
- **Evolution API** - WhatsApp (Baileys)
- **Mercado Pago** - Integração Pix

## 🚀 Instalação

### Pré-requisitos

- Docker 24.0+
- Docker Compose 2.0+
- 2GB RAM mínimo
- 10GB espaço em disco

### Passo a Passo

1. **Clone o repositório**

```bash
git clone https://github.com/mechama/pdv.git
cd mechama-pdv
```

2. **Configure as variáveis de ambiente**

```bash
cp backend/.env.example backend/.env
# Edite o arquivo .env com suas configurações
```

3. **Inicie os serviços**

```bash
# Modo básico (sem WhatsApp)
docker-compose up -d

# Modo completo (com WhatsApp)
docker-compose --profile completo up -d

# Modo produção (com Nginx)
docker-compose --profile producao up -d
```

4. **Acesse a aplicação**

- Frontend: http://localhost:5173
- API: http://localhost:8000
- Documentação API: http://localhost:8000/docs

5. **Crie o primeiro usuário**

```bash
# Acesse o container do backend
docker-compose exec backend python -c "
from app.core.database import sync_engine
from app.models.models import Base
from sqlalchemy.orm import sessionmaker
from app.services.auth_service import get_password_hash
from app.models.models import User

Session = sessionmaker(bind=sync_engine)
session = Session()

user = User(
    email='seu@email.com',
    password_hash=get_password_hash('sua-senha'),
    nome='Seu Nome',
    is_superuser=True
)
session.add(user)
session.commit()
print('Usuário criado com sucesso!')
"
```

## ⚙️ Configuração

### Mercado Pago (Pix)

1. Crie uma conta em [Mercado Pago Developers](https://www.mercadopago.com.br/developers)
2. Gere suas credenciais de teste/produção
3. Adicione ao `.env`:

```env
MERCADO_PAGO_PUBLIC_KEY=TEST-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
MERCADO_PAGO_ACCESS_TOKEN=TEST-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### Evolution API (WhatsApp)

1. O serviço já está incluído no docker-compose
2. Acesse `http://localhost:8080`
3. Crie uma instância e escaneie o QR Code
4. Configure a instância nas configurações da empresa

### Configurações da Empresa

Acesse as configurações para personalizar:

- **Dados da empresa** - nome, CNPJ, endereço
- **Fiscal** - NF-e/NFC-e (opcional, desativado por padrão)
- **Pix** - chave Pix e integração Mercado Pago
- **WhatsApp** - instância Evolution API
- **Vendas** - comportamento do PDV

## 📖 Uso

### Fluxo de Venda

1. **Adicione produtos** ao carrinho (clique ou busca)
2. **Ajuste quantidades** e aplique descontos
3. **Selecione o cliente** (opcional)
4. **Clique em "Finalizar"**
5. **Escolha a forma de pagamento**
6. **Confirme** a venda

### Modo Ambulante/Feira

Ideal para vendedores que trabalham em feiras e eventos:

- Interface simplificada
- Botões grandes para touch
- Venda rápida sem código de barras
- Caixa do dia com troco inicial/final

### Envio de Comprovante WhatsApp

1. Na finalização, marque "Enviar comprovante"
2. Informe o número do cliente
3. O comprovante é enviado automaticamente!

## 🔌 API

A API REST está documentada em OpenAPI/Swagger:

- **Desenvolvimento**: http://localhost:8000/docs
- **Redoc**: http://localhost:8000/redoc

### Endpoints Principais

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/api/v1/auth/login` | Login de usuário |
| POST | `/api/v1/auth/register` | Registro de usuário |
| GET | `/api/v1/auth/me` | Dados do usuário logado |
| GET | `/api/v1/produtos/` | Listar produtos |
| POST | `/api/v1/produtos/` | Criar produto |
| GET | `/api/v1/clientes/` | Listar clientes |
| POST | `/api/v1/vendas/finalizar` | Finalizar venda |
| GET | `/api/v1/vendas/dashboard/hoje` | Dashboard do dia |
| POST | `/api/v1/pix/gerar` | Gerar QR Code Pix |
| POST | `/api/v1/whatsapp/enviar` | Enviar mensagem WhatsApp |

## 🤝 Contribuição

Contribuições são bem-vindas! Veja como ajudar:

### Reportar Bugs

Use as [Issues](https://github.com/mechama/pdv/issues) do GitHub

### Sugerir Features

Abra uma [Discussion](https://github.com/mechama/pdv/discussions)

### Contribuir Código

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Add nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

### Doar

Ajude a manter o projeto gratuito:

- **Pix**: `doacoes@mechama.pdv`
- **PicPay**: @mechamapdv
- **Patreon**: [patreon.com/mechamapdv](https://patreon.com/mechamapdv)

## 📱 Grupo WhatsApp

Entre no grupo oficial para:
- 📢 Novidades e atualizações
- ❓ Tirar dúvidas
- 💡 Compartilhar dicas
- 🤝 Networking com outros empreendedores

**Link**: [Mechama PDV - Dúvidas e Dicas](https://chat.whatsapp.com/mechama-pdv)

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

---

<p align="center">
  <strong>💚 Feito com amor pelo povo brasileiro 🇧🇷</strong>
</p>

<p align="center">
  <sub>Mechama PDV - 2024 - O PDV do povo</sub>
</p>
