# Calendário de Tarefas

Software desktop para registro diário de tarefas e controle de horas trabalhadas, desenvolvido em Flutter com foco em Clean Architecture e boas práticas de desenvolvimento.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20MVVM-7C6EF5)

---

## Sobre o Projeto

O **Calendário de Tarefas** nasceu da necessidade de substituir um controle manual em bloco de notas por uma ferramenta mais visual e eficiente. O objetivo é registrar as tarefas do dia de trabalho com o tempo gasto em cada uma, permitindo uma visão clara da produtividade ao longo da semana e do mês.

O projeto serve também como estudo prático de **Clean Architecture** aplicada ao Flutter Desktop, explorando separação de responsabilidades, fluxo unidirecional de dados e boas práticas de desenvolvimento.

---

## Funcionalidades

### Calendário

- Navegação por mês com visualização completa
- Seleção de dia para visualizar e registrar tarefas
- Destaque visual para o dia atual
- Botão de atalho para voltar ao dia de hoje

### Registro de Tarefas

- Adicionar tarefas com título, descrição e tempo gasto (horas e minutos)
- Visualizar detalhes de cada tarefa
- Editar tarefas existentes
- Excluir tarefas com confirmação
- Total de horas do dia calculado automaticamente
- Meta diária configurável com barra de progresso

### Timesheet

- Visualização semanal das tarefas por dia
- Visualização mensal com grade completa
- Navegação entre períodos
- Total de horas do período em destaque
- Exportação para Markdown (.md) com resumo das tarefas

### Configurações

- Tema claro, escuro ou seguindo o sistema operacional
- Meta diária de horas configurável
- Opção de iniciar o app junto com o Windows
- Exportar banco de dados (backup)
- Importar banco de dados (restaurar backup)

### Visual

- Tema dark moderno com suporte a tema claro
- Gradientes personalizáveis via extensão de tema
- Sidebar retrátil com hover para expandir
- Splash screen de inicialização
- Interface responsiva para diferentes tamanhos de janela

---

## Arquitetura

O projeto segue **Clean Architecture orientada a módulos (Feature-Based)**, combinada com o padrão **MVVM** na camada de apresentação.

```
lib/
├── core/                          # Recursos compartilhados
│   ├── extensions/                # Extensions do Dart/Flutter
│   ├── theme/                     # Tema global (AppTheme, AppGradient)
│   ├── ui_components/             # Widgets reutilizáveis (Calendário, Sidebar)
│   └── utils/                     # Utilitários (AppDateUtils)
│
└── features/                      # Funcionalidades por contexto de negócio
    ├── configuracoes/
    │   ├── data/                  # Datasource (SharedPreferences) + Repository
    │   ├── domain/                # Entity + Interface do repositório
    │   └── presentation/          # Page + ViewModel
    ├── home/
    │   └── presentation/          # HomePage com navegação via Sidebar
    ├── splash/
    │   └── presentation/          # SplashPage com inicialização do app
    ├── tarefas/
    │   ├── data/                  # DatabaseHelper + Datasource + DTO + Repository
    │   ├── domain/                # TarefaEntity + Interface do repositório
    │   └── presentation/          # Page + ViewModels + Widgets
    └── timesheet/
        └── presentation/          # Page + ViewModel + Widgets
```

### Fluxo de Dados

```
UI (Widget) → ViewModel → Repository → Datasource → Banco/Prefs
                ↑                                        |
                └────────────── Entity ◄─────────────────┘
```

- **Widgets** são passivos — só exibem dados e disparam callbacks
- **ViewModels** orquestram o estado e chamam os repositórios
- **Repositories** convertem DTO ↔ Entity e delegam ao Datasource
- **Datasources** executam queries SQL e leem/escrevem nas preferências
- **Entities** são objetos puros de domínio, sem dependências externas

---

## Tecnologias

| Tecnologia                                                        | Uso                                    |
| ----------------------------------------------------------------- | -------------------------------------- |
| [Flutter](https://flutter.dev)                                    | Framework principal                    |
| [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi) | Banco de dados SQLite para desktop     |
| [path_provider](https://pub.dev/packages/path_provider)           | Localização de diretórios do sistema   |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Persistência de configurações          |
| [window_manager](https://pub.dev/packages/window_manager)         | Controle da janela no Windows          |
| [launch_at_startup](https://pub.dev/packages/launch_at_startup)   | Iniciar com o Windows                  |
| [file_picker](https://pub.dev/packages/file_picker)               | Seleção de arquivo para importação     |
| [restart_app](https://pub.dev/packages/restart_app)               | Reiniciar app após importação de banco |
| [path](https://pub.dev/packages/path)                             | Manipulação de caminhos de arquivo     |
| [yaml](https://pub.dev/packages/yaml)                             | Leitura da versão do pubspec.yaml      |

---

## Como Executar

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.x ou superior
- [Visual Studio](https://visualstudio.microsoft.com/) com suporte a C++ (para Windows)
- Windows 10 ou superior

### Passos

```bash
# Clone o repositório
git clone https://github.com/vitordmfonseca-jpg/projeto-tarefas.git

# Acesse a pasta do projeto
cd tarefas_calendario

# Instale as dependências
flutter pub get

# Execute o projeto
flutter run -d windows
```

## Download

Prefere instalar direto sem compilar? Baixe o instalador mais recente na página de [Releases](https://github.com/vitordmfonseca-jpg/projeto-tarefas/releases).

### Build para produção

```bash
flutter build windows
```

O executável será gerado em `build/windows/x64/runner/Release/`.

---

## Banco de Dados

O banco SQLite é armazenado em:

```
C:\Users\{usuario}\AppData\Roaming\{app_id}\tarefas_calendario\tarefas.db
```

O app oferece opções nativas de **Exportar** e **Importar** o banco de dados pela tela de Configurações, permitindo migrar os dados entre máquinas.

---

## Decisões Técnicas

**Clean Architecture** — A separação em camadas garante que mudanças de infraestrutura (ex: trocar SQLite por uma API) não impactem as regras de negócio. O domínio é completamente isolado de frameworks e bibliotecas externas.

**ViewModel com ChangeNotifier** — Solução nativa do Flutter para gerenciamento de estado simples, sem dependências externas. O padrão `set estado { _estado = valor; notifyListeners(); }` garante que a UI sempre seja notificada quando o estado muda.

**SQLite com sqflite_common_ffi** — O `sqflite` padrão não suporta desktop. O `sqflite_common_ffi` resolve isso usando FFI (Foreign Function Interface) para comunicar com a lib nativa do SQLite no Windows.

**Datasource por feature** — Cada feature cria sua própria tabela no banco via `CREATE TABLE IF NOT EXISTS`, evitando que o `DatabaseHelper` cresça indefinidamente conforme o app evolui.

---

## Autor

**Vitor Fonseca**

Desenvolvedor Flutter com 5 anos de experiência, explorando Clean Architecture e boas práticas de desenvolvimento de software.

---

## Licença

Este projeto é de uso pessoal e educacional.
