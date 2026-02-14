# 🟢🟡 Mechama PDV - Arquitetura do Sistema

## Diagrama de Arquitetura

```mermaid
graph TB
    subgraph "Cliente (PWA)"
        A[📱 Mobile App / 💻 Desktop]
        A --> B[Service Worker]
        B --> C[IndexedDB Cache]
        A --> D[React + Tailwind + shadcn/ui]
    end

    subgraph "VPS Cloud (Docker Compose)"
        subgraph "Frontend"
            E[Nginx - Static Files]
        end

        subgraph "Backend"
            F[FastAPI - Python]
            F --> G[Uvicorn ASGI]
        end

        subgraph "Serviços"
            H[Evolution API<br/>WhatsApp Baileys]
            I[Redis - Cache/Fila]
        end

        subgraph "Banco de Dados"
            J[PostgreSQL 15]
            K[Backup Automático]
        end
    end

    subgraph "Integrações Externas"
        L[Mercado Pago API<br/>Pix QR Dinâmico]
        M[WhatsApp Web<br/>Envio Comprovantes]
    end

    A <-->|HTTPS/JSON| F
    E --> A
    F <-->|SQLAlchemy| J
    F <-->|Redis| I
    F <-->|HTTP| H
    H <-->|Baileys| M
    F <-->|REST| L

    style A fill:#E8F5E9,stroke:#009C3B,stroke-width:2px
    style F fill:#E8F5E9,stroke:#009C3B,stroke-width:2px
    style J fill:#FFF9C4,stroke:#FFDF00,stroke-width:2px
    style H fill:#FFF9C4,stroke:#FFDF00,stroke-width:2px
```

## Fluxo de Dados - Venda Completa

```mermaid
sequenceDiagram
    participant U as 👤 Usuário
    participant PWA as 📱 PWA React
    participant API as ⚡ FastAPI
    participant DB as 🐘 PostgreSQL
    participant WA as 💬 Evolution API
    participant MP as 💳 Mercado Pago
    participant WWeb as 📲 WhatsApp Web

    U->>PWA: Adiciona produtos ao carrinho
    PWA->>API: POST /api/vendas/calcular-total
    API-->>PWA: Retorna total com descontos

    alt Pagamento Pix
        U->>PWA: Seleciona Pix
        PWA->>API: POST /api/pix/gerar-qr
        API->>MP: Cria cobrança Pix
        MP-->>API: Retorna QR Code + copia-cola
        API-->>PWA: Exibe QR para scan
        U->>WWeb: Paga via app bancário
        MP->>API: Webhook confirma pagamento
    else Pagamento Dinheiro/Cartão
        U->>PWA: Informa pagamento
    end

    U->>PWA: Finaliza venda
    PWA->>API: POST /api/vendas/finalizar
    API->>DB: Salva venda + itens + atualiza estoque
    DB-->>API: Confirma transação

    opt Envio WhatsApp
        API->>WA: POST /message/sendText
        WA->>WWeb: Envia comprovante PDF
        WWeb-->>U: 📄 Comprovante recebido
    end

    API-->>PWA: ✅ Venda concluída
    PWA->>U: Mostra recibo + agradecimento
```

## Estrutura Multi-Tenant

```mermaid
graph LR
    subgraph "Banco PostgreSQL - Isolamento por Schema"
        direction TB
        
        subgraph "Schema: tenant_001"
            A1[empresa]
            B1[produtos]
            C1[vendas]
            D1[clientes]
        end
        
        subgraph "Schema: tenant_002"
            A2[empresa]
            B2[produtos]
            C2[vendas]
            D2[clientes]
        end
        
        subgraph "Schema: tenant_003"
            A3[empresa]
            B3[produtos]
            C3[vendas]
            D3[clientes]
        end
        
        Z[public.users<br/>Autenticação central]
    end

    U1[👤 Loja da Maria] --> A1
    U2[👤 Mercado do João] --> A2
    U3[👤 Salão Beleza] --> A3
```

## Stack Tecnológico

| Camada | Tecnologia | Versão | Propósito |
|--------|-----------|--------|-----------|
| **Frontend** | React | 18+ | UI interativa |
| | TypeScript | 5+ | Tipagem segura |
| | Vite | 5+ | Build rápido |
| | Tailwind CSS | 3.4+ | Estilos utilitários |
| | shadcn/ui | latest | Componentes UI |
| | PWA | - | Offline capability |
| | Zustand | - | State management |
| **Backend** | Python | 3.11+ | Linguagem principal |
| | FastAPI | 0.104+ | API REST |
| | SQLAlchemy | 2+ | ORM |
| | Pydantic | 2+ | Validação dados |
| | Celery | - | Tarefas assíncronas |
| **Banco** | PostgreSQL | 15+ | Dados persistentes |
| | Redis | 7+ | Cache e filas |
| **WhatsApp** | Evolution API | latest | Baileys-based |
| **Pix** | Mercado Pago | API v1 | QR dinâmico |
| **Deploy** | Docker | 24+ | Containerização |
| | Nginx | latest | Reverse proxy |

## Segurança

- 🔐 JWT tokens com refresh
- 🔒 HTTPS obrigatório (Let's Encrypt)
- 🛡️ Rate limiting por tenant
- 📝 Audit logs de vendas
- 💾 Backup criptografado diário

## Escalabilidade

- Horizontal: múltiplas replicas FastAPI
- Vertical: upgrade VPS conforme crescimento
- Cache Redis para produtos frequentes
- CDN para imagens (Cloudflare R2 gratuito)
