# AB Client — контекст для продолжения в Claude Code

Это саммари сессии с Claude (Cowork), чтобы продолжить работу над проектом локально в Claude Code.
Положи этот файл в корень репозитория (`ab_client/HANDOFF.md`) и укажи Claude Code на него в начале
новой сессии.

## Что это за проект

Flutter-клиент (admin-панель) для кастомного A/B-тестинг сервиса. Бэкенд — микросервисы на Go,
лежат в `C:\Users\razor\GolandProjects\`:

- `ab-gate-way` — единственный сервис, с которым сейчас работает клиент (REST-шлюз, `docs/echo/openapi.yaml`)
- `ab-microservice`, `auth-micro-service`, `notification_service`, `cdp-segment-loader`,
  `cdp-segment-manager` — есть в репозиториях, но клиент их пока не касается

Сам Flutter-проект живёт на диске пользователя:
`C:\Users\razor\OneDrive\Рабочий стол\ab-client\ab_client\`

## Архитектура

- HTTP: `dio` + `dio_cookie_manager`/`cookie_jar` — сессия живёт в cookie, которую ставит гейт (не в
  теле JSON-ответа).
- Слои:
  - `lib/core/network/` — транспорт: `ApiClient`, `ApiException`, `GatewayApiBase`,
    `RefreshOn401Interceptor` (single-flight refresh-and-retry на 401).
  - `lib/features/<domain>/data/` — модели + API-класс на домен.
  - `lib/features/<domain>/presentation/` — `ChangeNotifier`-контроллеры + экраны/диалоги. Никаких
    provider/riverpod/bloc — явный DI через конструкторы.
  - `lib/common/` — переиспользуемые примитивы: `AsyncListController<T>` (машина состояний
    load/loading/error/empty) + `AsyncListView<T>`, `FeatureScaffold`, `FormDialog`.
- Домены (каждый: `create*`, `get*List`, `get*ById`, плюс свои операции):
  `auth`, `users`, `namespaces`, `layers`, `custom_params`, `feature_toggles`, `experiments`.
- Навигация: `NavigationRail` (широкий экран) / `Drawer` (узкий), через `MediaQuery` — см.
  `lib/features/shell/presentation/admin_shell.dart`.

## Мок-режим (главная фича последней сессии)

Пользователь попросил: сделать мок-данные фиче-флагом из env, чтобы приложение полностью работало
без поднятого бэкенда.

Реализовано через `--dart-define=USE_MOCK_API=true`:

- Каждый `*Api`-класс превращён в **интерфейс** (`abstract class AuthApi { ... }` и т.д., файлы
  `lib/features/<domain>/data/<domain>_api.dart`) — контроллеры и экраны типизированы на эти
  интерфейсы и не видят разницы, что за реализация под капотом.
- Реальная реализация вынесена в `Gateway<Domain>Api` (`lib/features/<domain>/data/gateway_<domain>_api.dart`),
  логика 1-в-1 скопирована из старых классов, просто `extends GatewayApiBase implements <Domain>Api`.
- Мок-реализация — `lib/core/mock/`:
  - `mock_backend.dart` — общий изменяемый `MockBackend` (списки namespaces/layers/customParams/
    featureToggles/experiments/users + счётчики id), с сид-данными (2 неймспейса, 2 слоя, 2
    кастом-парама, 3 фича-тоггла, 2 эксперимента, один демо-юзер) и симуляцией сетевой задержки
    (`mockLatency()`, ~320ms).
  - `mock_auth_api.dart`, `mock_users_api.dart`, `mock_namespaces_api.dart`, `mock_layers_api.dart`,
    `mock_custom_params_api.dart`, `mock_feature_toggles_api.dart`, `mock_experiments_api.dart` —
    по одному на домен, все держат ссылку на общий `MockBackend`.
- `lib/core/config/app_config.dart` — добавлен `static const bool useMockApi = bool.fromEnvironment('USE_MOCK_API')`.
  **Важно:** это `static` геттер на классе, обращаться нужно как `AppConfig.useMockApi`, а не через
  инстанс `config.useMockApi` (была и уже исправлена ошибка анализатора `instance_access_to_static_member`).
- `lib/gateway_client.dart` — `GatewayClient.create()` ветвится: если `AppConfig.useMockApi` — вообще
  не создаёт `ApiClient`/Dio, собирает `GatewayClient` из моков вокруг одного `MockBackend`; иначе —
  как раньше. Добавлено поле `GatewayClient.isMock`.
- `lib/app.dart` — при `isMock == true` весь `MaterialApp` оборачивается в `Banner` (оранжевая лента
  "DEMO" в углу) через `builder:`.
- `lib/features/auth/presentation/login_screen.dart` — при `isMock == true` на экране логина
  показывается карточка с демо-доступом и кнопкой "Подставить".

**Демо-учётка:** `admin@example.com` / `demo1234` (задана в `MockBackend`, константы
`MockBackend.demoMail` / `MockBackend.demoPassword`). Регистрация нового пользователя тоже работает
полностью локально (сохраняется только в памяти процесса, до перезапуска).

**Как запускать:**

```
flutter run -d chrome --dart-define=USE_MOCK_API=true
flutter build web --dart-define=USE_MOCK_API=true
```

Без флага — как раньше, реальный бэкенд на `http://localhost:8080`.

## Известные проблемы / не доведено до конца

1. **Белый экран на `localhost:52316` (flutter web) — не продиагностирован до конца.** Возник до
   запроса про моки; сам мок-режим это не чинит, а скорее обходит стороной. Не было доступа ни к
   Chrome-расширению (не подключено), ни к встроенному браузеру (не смог достучаться до
   `localhost:52316` с той стороны). Нужно посмотреть консоль браузера/вывод `flutter run` вживую —
   если экран всё ещё белый и в мок-режиме, значит дело не в бэкенде, а в самой web-сборке.
2. `flutter analyze` / `flutter pub get` ни разу не запускались в облачной песочнице (там нет
   Flutter SDK) — весь мок-рефакторинг вычитан вручную. Стоит прогнать анализатор локально перед тем
   как считать задачу полностью закрытой; один инстанс-баг (`config.useMockApi` →
   `AppConfig.useMockApi`) уже словили и поправили именно так.
3. Остальные бэкенд-сервисы (`ab-microservice`, `auth-micro-service`, `notification_service`,
   `cdp-segment-loader`, `cdp-segment-manager`) ещё не смотрели — пользователь просил начать с гейта,
   этим и ограничились.

## Что могло не попасть в этот файл

Полная история диалога (включая точные тексты сообщений пользователя, разбор `openapi.yaml`,
разбор всех найденных багов компиляции) — в истории чата Cowork. Если Claude Code упрётся в вопрос
"а почему тут так", скорее всего ответ там же.
