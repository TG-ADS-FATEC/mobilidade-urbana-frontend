# 📱 Mobilidade Urbana App — Frontend Flutter

Aplicativo mobile de mobilidade urbana desenvolvido com Flutter.

---

## 🚀 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>= 3.x.x`
- [Dart SDK](https://dart.dev/get-dart) (incluído no Flutter)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/)
- Emulador Android/iOS ou dispositivo físico

Para verificar se o ambiente está configurado corretamente:

```bash
flutter doctor
```

---

## ⚙️ Configuração do Projeto

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/mobilidade_urbana_app.git
cd mobilidade_urbana_app
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure as variáveis de ambiente

Crie um arquivo `.env` na raiz do projeto baseado no `.env.example`:

```bash
cp .env.example .env
```

Preencha as variáveis necessárias (URL da API, chaves, etc.).

---

## ▶️ Rodando o App

### Modo desenvolvimento

```bash
flutter run
```

### Escolher dispositivo específico

```bash
# Lista dispositivos disponíveis
flutter devices

# Roda em um dispositivo específico
flutter run -d <device_id>
```

### Build de produção

```bash
# Android — APK
flutter build apk --release

# Android — App Bundle (recomendado para Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 🎨 Ícone do App — flutter_launcher_icons

A configuração do ícone está em [`flutter_launcher_icons.yaml`](./flutter_launcher_icons.yaml).

Para gerar os ícones em todos os tamanhos/plataformas após alterar o arquivo de imagem ou a config:

```bash
dart run flutter_launcher_icons
```

> **Arquivo de ícone:** `assets/icon/icon.png`
> **Cor de fundo do ícone adaptativo (Android):** `#D4FF73`

---

## 💦 Splash Screen — flutter_native_splash

A configuração da splash screen fica em [`splash.yaml`](./splash.yaml).

Para gerar a splash nativa após alterar a configuração:

```bash
dart run flutter_native_splash:create --path=splash.yaml
```

Para remover a splash nativa gerada (voltar ao padrão):

```bash
dart run flutter_native_splash:remove --path=splash.yaml
```

---

## 🏗️ Geração de Código — build_runner

O projeto usa `build_runner` para geração de código (ex: adaptadores do Hive). Após criar ou alterar classes anotadas:

```bash
# Geração única
dart run build_runner build

# Modo watch — regera automaticamente ao salvar
dart run build_runner watch

# Limpa arquivos gerados antes de regerar (resolve conflitos)
dart run build_runner build --delete-conflicting-outputs
```

---

## 🧹 Limpeza e Reset

Use esses comandos quando encontrar problemas de cache ou build corrompido:

```bash
# Limpa arquivos de build
flutter clean

# Reinstala as dependências
flutter pub get
```

Para uma limpeza completa incluindo o cache global:

```bash
flutter clean
dart pub cache clean
flutter pub get
```

---

## 📁 Estrutura de Pastas

```
lib/
├── core/
│   ├── data_state/         # Tipos de resultado (DataSuccess / DataFailed)
│   ├── di/                 # Injeção de dependência (GetIt)
│   ├── error/              # Tipos de falha
│   ├── network/            # Cliente HTTP (Dio)
│   ├── router/             # Rotas (GoRouter)
│   ├── services/           # Auth, DeviceToken, Onboarding
│   └── widgets/            # Widgets reutilizáveis globais
├── features/
│   ├── favorites/          # Favoritos (CRUD + armazenamento local)
│   ├── home/               # Tela principal e busca
│   ├── onboarding/         # Fluxo de preferências iniciais
│   ├── profile/            # Perfil e preferências do usuário
│   ├── travel/             # Planejamento de viagem
│   └── welcome/            # Tela de boas-vindas
├── utils/
│   ├── constants/          # Cores, tamanhos, textos, enums
│   ├── helpers/            # Funções utilitárias
│   ├── theme/              # Tema claro e escuro
│   └── validators/         # Validadores de formulário
└── main.dart
```

Cada feature segue a arquitetura limpa:

```
features/<nome>/
├── data/
│   ├── data_sources/       # Chamadas remotas (API)
│   ├── models/             # Modelos com fromJson / toJson
│   └── repository/         # Implementação dos repositórios
├── domain/
│   ├── entities/           # Objetos de domínio puros
│   ├── repository/         # Interfaces dos repositórios
│   └── usecases/           # Casos de uso / regras de negócio
└── presentation/
    ├── controllers/        # Providers Riverpod (Notifier)
    ├── screens/            # Telas
    └── widgets/            # Widgets da feature
```

---

## 🔗 Conexão com o Backend

O backend e banco de dados rodam via Docker. Certifique-se de que os containers estão ativos antes de rodar o app.

```bash
# Na pasta do backend
docker compose up
```

Para reiniciar o ambiente do zero:

```bash
# Para containers e remove volumes
docker compose down -v --rmi all

# Sobe novamente com rebuild
docker compose up --build
```

> O endereço padrão do backend no emulador Android é `http://10.0.2.2:8080`.
> Para dispositivo físico, substitua pelo IP da máquina na rede local.

---

## 🛠️ Tecnologias

| Pacote | Uso |
|---|---|
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | Gerenciamento de estado |
| [go_router](https://pub.dev/packages/go_router) | Navegação declarativa |
| [get_it](https://pub.dev/packages/get_it) | Injeção de dependência |
| [dio](https://pub.dev/packages/dio) | Cliente HTTP |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | Persistência local (chave-valor) |
| [hive](https://pub.dev/packages/hive) | Banco local NoSQL |
| [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) | Variáveis de ambiente |
| [flutter_map](https://pub.dev/packages/flutter_map) | Mapas |
| [flutter_svg](https://pub.dev/packages/flutter_svg) | Renderização de SVG |
| [lottie](https://pub.dev/packages/lottie) | Animações |
| [equatable](https://pub.dev/packages/equatable) | Igualdade de valor em entidades |
| [uuid](https://pub.dev/packages/uuid) | Geração de UUIDs |
| [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) | Geração de ícones |
| [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) | Splash screen nativa |
| [permission_handler](https://pub.dev/packages/permission_handler) | Gerenciamento de permissões |

---

## 🤝 Contribuindo

1. Crie uma branch: `git checkout -b feature/minha-feature`
2. Faça suas alterações e commit: `git commit -m 'feat: minha feature'`
3. Envie para o repositório: `git push origin feature/minha-feature`
4. Abra um Pull Request
