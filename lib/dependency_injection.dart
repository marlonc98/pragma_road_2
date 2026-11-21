import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/data/repositories/character/character_repository_impl.dart';
import 'package:portal_remoto/data/repositories/character/character_repository_mock.dart';
import 'package:portal_remoto/data/repositories/localization/localization_repository_impl.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';
import 'package:portal_remoto/domain/repositories/localization_repository.dart';
import 'package:portal_remoto/domain/use_cases/character/get_character_by_id_use_case.dart';
import 'package:portal_remoto/domain/use_cases/character/search_characters_use_case.dart';
import 'package:portal_remoto/domain/use_cases/load_use_case.dart';
import 'package:portal_remoto/flavors/flavors.dart';
import 'package:portal_remoto/presentation/states/localization_state_impl.dart';

// Datos remotos: se configura una sola vez aquí
// Repositorios
final localizationRepositoryProvider = Provider<LocalizationRepository>(
  (ref) => LocalizationRepositoryImpl(),
);
final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => switch (F.appFlavor) {
    Flavor.mock => CharacterRepositoryMock(),
    Flavor.dev || Flavor.prod => CharacterRepositoryImpl(),
  },
);

// Estados
final localizationStateProvider =
    NotifierProvider<LocalizationStateImpl, Map<String, String>>(
      LocalizationStateImpl.new,
    );

// Casos de uso
final loadUseCaseProvider = Provider<LoadUseCase>(
  (ref) => LoadUseCase(
    localizationState: ref.watch(localizationStateProvider.notifier),
  ),
);

// Casos de uso: personajes
final searchCharactersUseCaseProvider = Provider<SearchCharactersUseCase>(
  (ref) => SearchCharactersUseCase(
    characterRepository: ref.watch(characterRepositoryProvider),
  ),
);
final getCharacterByIdUseCaseProvider = Provider<GetCharacterByIdUseCase>(
  (ref) => GetCharacterByIdUseCase(
    characterRepository: ref.watch(characterRepositoryProvider),
  ),
);
