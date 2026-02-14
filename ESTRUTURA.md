# 🟢🟡 Mechama PDV - Estrutura do Projeto

```
mechama-pdv/
├── 📁 backend/                    # Backend FastAPI
│   ├── 📁 app/
│   │   ├── 📁 api/               # Endpoints REST
│   │   │   ├── auth.py           # Autenticação JWT
│   │   │   ├── vendas.py         # Vendas e PDV
│   │   │   ├── pix.py            # Integração Pix
│   │   │   └── whatsapp.py       # Integração WhatsApp
│   │   ├── 📁 core/              # Configurações core
│   │   │   ├── config.py         # Configurações do app
│   │   │   └── database.py       # Conexão PostgreSQL
│   │   ├── 📁 models/            # Modelos de dados
│   │   │   ├── models.py         # Modelos SQLAlchemy
│   │   │   ├── schemas.py        # Schemas Pydantic
│   │   │   └── schema.sql        # Script SQL completo
│   │   ├── 📁 services/          # Lógica de negócio
│   │   │   ├── auth_service.py   # Serviço de autenticação
│   │   │   ├── pix_service.py    # Serviço Pix (Mercado Pago)
│   │   │   └── whatsapp_service.py # Serviço WhatsApp (Evolution)
│   │   ├── 📁 utils/             # Utilitários
│   │   └── main.py               # Entry point FastAPI
│   ├── Dockerfile                # Container backend
│   ├── requirements.txt          # Dependências Python
│   └── .env.example              # Variáveis de ambiente
│
├── 📁 frontend/                   # Frontend React
│   ├── 📁 src/
│   │   ├── 📁 components/        # Componentes React
│   │   │   ├── Header.tsx        # Cabeçalho da aplicação
│   │   │   └── 📁 pdv/           # Componentes do PDV
│   │   │       ├── Carrinho.tsx      # Carrinho de compras
│   │   │       ├── ListaProdutos.tsx # Grid de produtos
│   │   │       ├── PagamentoModal.tsx # Modal de pagamento
│   │   │       └── PixModal.tsx       # Modal Pix QR Code
│   │   ├── 📁 hooks/             # Custom hooks
│   │   ├── 📁 lib/               # Utilitários
│   │   │   └── utils.ts          # Funções auxiliares
│   │   ├── 📁 pages/             # Páginas (para rotas futuras)
│   │   ├── 📁 services/          # Serviços de API
│   │   │   └── api.ts            # Cliente Axios
│   │   ├── 📁 store/             # Estado global (Zustand)
│   │   │   └── index.ts          # Stores auth, carrinho, etc
│   │   ├── 📁 types/             # Tipos TypeScript
│   │   │   └── index.ts          # Interfaces e types
│   │   ├── App.tsx               # Componente principal
│   │   ├── main.tsx              # Entry point React
│   │   └── index.css             # Estilos globais
│   ├── 📁 public/                # Assets estáticos
│   ├── package.json              # Dependências Node
│   ├── tailwind.config.js        # Config Tailwind
│   ├── vite.config.ts            # Config Vite
│   └── tsconfig.json             # Config TypeScript
│
├── 📁 docker/                     # Configurações Docker
│   └── 📁 nginx/
│       └── nginx.conf            # Config proxy reverso
│
├── 📁 docker-docs/                # Documentação Docker
│
├── docker-compose.yml             # Orquestração de containers
├── .env.example                   # Variáveis de ambiente
├── Makefile                       # Comandos úteis
├── ARQUITETURA.md                 # Diagramas e arquitetura
├── ESTRUTURA.md                   # Este arquivo
├── README.md                      # Documentação principal
└── LICENSE                        # Licença MIT
```

## 📊 Estatísticas

| Componente | Arquivos | Linhas de Código |
|------------|----------|------------------|
| Backend | 15 | ~3.500 |
| Frontend | 20+ | ~2.500 |
| Database | 1 | ~600 |
| Docker | 3 | ~200 |
| **Total** | **40+** | **~6.800** |

## 🔧 Tecnologias Principais

### Backend
- **FastAPI** - Framework web assíncrono
- **SQLAlchemy 2.0** - ORM moderno
- **PostgreSQL** - Banco relacional
- **Pydantic** - Validação de dados
- **JWT** - Autenticação

### Frontend
- **React 18** - UI declarativa
- **TypeScript** - Tipagem estática
- **Tailwind CSS** - Estilos utilitários
- **shadcn/ui** - Componentes acessíveis
- **Zustand** - Estado global simples

### Infraestrutura
- **Docker** - Containerização
- **Nginx** - Proxy reverso
- **Redis** - Cache e filas

## 🎯 Módulos do Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                      MECHAMA PDV                            │
├─────────────────────────────────────────────────────────────┤
│  🛒 PDV        │  📊 Gestão      │  💬 Comunicação          │
│  ───────────── │  ────────────── │  ─────────────────       │
│  • Venda       │  • Produtos     │  • WhatsApp              │
│  • Carrinho    │  • Estoque      │  • Comprovantes          │
│  • Pagamento   │  • Clientes     │  • Catálogo digital      │
│  • Pix QR      │  • Relatórios   │                          │
│  • Descontos   │  • Dashboard    │                          │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Fluxo de Dados

```
Usuário → Frontend (React) → API (FastAPI) → PostgreSQL
                ↓                    ↓
           LocalStorage          Redis (cache)
                ↓                    ↓
           PWA (offline)      Evolution API (WhatsApp)
                                     ↓
                              Mercado Pago (Pix)
```

## 📱 PWA - Recursos Offline

- ✅ Cache de produtos
- ✅ Vendas offline (sync posterior)
- ✅ IndexedDB para dados locais
- ✅ Service Worker
- ✅ Instalação no celular

## 🔐 Segurança

- JWT tokens com refresh
- Senhas hasheadas (bcrypt)
- CORS configurado
- Rate limiting
- SQL injection protegido (ORM)
- XSS protegido (React)
