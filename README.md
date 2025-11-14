# 📱 Todo App -- Gerenciador de Tarefas

Um aplicativo simples e funcional desenvolvido em Flutter para
gerenciamento de tarefas diárias.\
Ele permite criar, editar, excluir e marcar tarefas como concluídas,
além de organizar tudo em uma interface limpa e intuitiva.\
O objetivo do projeto é demonstrar boas práticas de arquitetura,
gerenciamento de estado e testes unitários.

## 🚀 Tecnologias utilizadas

-   **Flutter 3.x**
-   **Dart**
-   **Provider** (gerenciamento de estado)
-   **UUID** (geração de IDs únicos)
-   **Material Design**
-   **Testes unitários** com `flutter_test`

## 📂 Arquitetura

-   `models/` -- modelos da aplicação (Todo)
-   `providers/` -- lógica de negócio e estado (TodoProvider)
-   `screens/` -- telas e interface
-   `widgets/` -- componentes reutilizáveis
-   `test/` -- testes unitários

## 🛠️ Como rodar o projeto

### 1. Clonar o repositório

``` sh
git clone https://github.com/ricardolino-hub/todo_list_flutter
cd todo_list_flutter
```

### 2. Instalar dependências

``` sh
flutter pub get
```

### 3. Rodar no emulador ou dispositivo

``` sh
flutter run
```

### 4. Executar testes

``` sh
flutter test
```

## 📦 Dependências principais

``` yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  uuid: ^4.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
```