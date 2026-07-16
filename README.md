# Calendário de Tarefas

Software desktop para Windows voltado ao registro diário de tarefas e controle de horas trabalhadas, desenvolvido em Flutter com Clean Architecture.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows)

<!-- TODO: adicionar screenshot ou gif do app aqui -->

## Sobre o projeto

O Calendário de Tarefas nasceu da necessidade de substituir um controle manual de tarefas e horas trabalhadas por uma ferramenta mais visual e organizada, com uma visão clara da produtividade ao longo da semana e do mês.

O projeto também serviu como estudo prático de Clean Architecture aplicada a um app Flutter Desktop real, explorando separação de responsabilidades e boas práticas de desenvolvimento.

## Funcionalidades

- Calendário mensal com indicativo visual de dias com tarefa registrada
- Registro de tarefas com título, descrição e tempo gasto
- Meta diária de horas configurável, com barra de progresso
- Timesheet semanal e mensal, com exportação para Markdown
- Backup e restauração do banco de dados
- Tema claro/escuro (ou seguindo o sistema), iniciar junto com o Windows

## Stack

Flutter · Dart · SQLite (`sqflite_common_ffi`) · `shared_preferences` · `window_manager`

## Arquitetura

Clean Architecture organizada por feature (`tarefas`, `timesheet`, `configuracoes`), com MVVM na camada de apresentação. Cada feature é dividida em três camadas:

- **domain** — entidades e regras de negócio, sem dependência de framework
- **data** — acesso ao SQLite e ao `shared_preferences`
- **presentation** — telas e ViewModels

Cada feature também tem sua própria injeção de dependência (`di/`); só o acesso ao banco é compartilhado entre elas.

## Como rodar

```bash
git clone https://github.com/vitordmfonseca-jpg/projeto-tarefas.git
cd tarefas_calendario
flutter pub get
flutter run -d windows
```

Ou baixe o instalador pronto na página de [Releases](https://github.com/vitordmfonseca-jpg/projeto-tarefas/releases/latest/download/inst_gerencia_tarefas.exe).

## Autor

**Vitor Fonseca** — desenvolvedor Flutter, 5 anos de experiência.

---

Projeto de uso pessoal e educacional.
