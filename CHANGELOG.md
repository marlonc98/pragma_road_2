# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/).

## [Sin publicar]

### Cambiado
- Dependencias de runtime reducidas de 10 a 3: `flutter_riverpod`, `http` y `go_router`.
- Se quitan `riverpod` (ya viene con `flutter_riverpod`) y `cupertino_icons` (no se usaba).
- `package_info_plus`: el splash lee la versión de `appBuildName` y `appBuildNumber` de Flutter.
- `shared_preferences`: la app es solo en español, así que no hay idioma que guardar.
- `connectivity_plus`: los errores de red salen de capturar `TimeoutException` y `SocketException`. Un wifi sin internet ya no se confunde con una petición lenta.
- `cached_network_image`: se reemplaza por `Image.network` con `loadingBuilder` y `errorBuilder`.
- `infinite_scroll_pagination`: se reemplaza por un `ScrollController` en el ViewModel del listado, con reintento al final de la lista.
- Los repositorios devuelven `Future<T>` y lanzan una clave de error. Los ViewModels guardan el estado en `AsyncValue` de Riverpod. Se eliminan `AsyncState`, `LoaderScreenWidget` y `NoResultsSmallWidget`.
- `CharacterRepositoryImpl` recibe el `RestApi` por constructor. Se elimina el `ProviderContainer` global (`di`) y los providers usan `ref.watch`.
- README resumido: qué hace, cómo correrlo, endpoints, estructura, dependencias y limitaciones.
- `pubspec.yaml` sin los comentarios del template y con descripción del proyecto.

### Eliminado
- Carpetas `linux`, `macos`, `windows` y `web`: la app se entrega solo para Android e iOS.
- Bloques `#region` de `dependency_injection.dart`.

## [1.0.0] - 2026-11-07

### Agregado
- Listado de personajes en cuadrícula con scroll infinito, búsqueda por nombre y *pull to refresh*.
- Detalle del personaje con imagen, estado, especie, tipo, género, origen, última ubicación e ID.
- Caché en memoria de los personajes ya cargados.
- Flavors `mock`, `dev` y `prod`.
- Tests del DTO, del repositorio con `MockClient`, del `RestApi` y de los casos de uso.
