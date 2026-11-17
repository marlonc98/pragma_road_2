# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/).

## [Sin publicar]

Cambios por la revisión de la Fase 2.

### Agregado
- `CHANGELOG.md`, para dejar registro de los cambios.
- Tests de `RestApi` (respuesta OK, 404, timeout, sin conexión) y de JSON inválido en el repositorio.

### Cambiado
- Dependencias de runtime de 10 a 3 (`flutter_riverpod`, `http`, `go_router`). Lo que hacían las otras se puede hacer con Flutter o Dart.
- Errores de red: se capturan `TimeoutException`, `SocketException` y `ClientException` en `RestApi` en vez de usar `connectivity_plus`. Es más preciso: un wifi sin internet ya no pasa como conectado.
- Imágenes con `Image.network` (`loadingBuilder` y `errorBuilder`) en vez de `cached_network_image`. Flutter ya las guarda en memoria.
- Paginación con un `ScrollController` en el ViewModel en vez de `infinite_scroll_pagination`. Son unas pocas variables y queda el reintento al final de la lista.
- La versión del splash sale de `appBuildName` y `appBuildNumber` de Flutter en vez de `package_info_plus`.
- Estado con `AsyncValue` de Riverpod en vez de mi `AsyncState`. Hacía lo mismo y `AsyncValue` ya trae `.when`.
- Los errores no se lanzan entre capas: `RestApi`, las funciones de la API, los repositorios y los casos de uso devuelven `AsyncData` o `AsyncError`, y el ViewModel guarda ese valor.
- `CharacterRepositoryImpl` recibe el `RestApi` por constructor y los providers usan `ref.watch`. Así las dependencias se ven y se pueden sobrescribir en tests.
- README más corto, con los endpoints y la razón de cada dependencia.
- `pubspec.yaml` con descripción del proyecto y sin los comentarios del template.

### Eliminado
- `riverpod`: ya viene dentro de `flutter_riverpod`.
- `cupertino_icons`: no se usaba.
- `shared_preferences`: solo guardaba el idioma y la app quedó solo en español (la API también responde solo en inglés).
- `ProviderContainer` global (`di`): escondía las dependencias y no dejaba hacer overrides.
- `LoaderScreenWidget` y `NoResultsSmallWidget`: con `AsyncValue.when` cada estado usa su widget, y el pequeño repetía al otro.
- Carpetas `linux`, `macos`, `windows` y `web`: las dejó `flutter create` y la app es solo para Android e iOS.
- Bloques `#region` de `dependency_injection.dart`: eran ruido.

## [1.0.0] - 2026-11-07

### Agregado
- Listado de personajes en cuadrícula con scroll infinito, búsqueda por nombre y *pull to refresh*.
- Detalle del personaje con imagen, estado, especie, tipo, género, origen, última ubicación e ID.
- Caché en memoria de los personajes ya cargados.
- Flavors `mock`, `dev` y `prod`.
- Tests del DTO, del repositorio con `MockClient`, del `RestApi` y de los casos de uso.
