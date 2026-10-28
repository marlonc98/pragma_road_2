import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/data/repositories/character/character_repository_impl.dart';
import 'package:portal_remoto/data/repositories/character/character_repository_mock.dart';
import 'package:portal_remoto/data/repositories/localization/localization_repository_impl.dart';
import 'package:portal_remoto/data/settings/rest_api.dart';
import 'package:portal_remoto/data/settings/rick_and_morty_api.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';
import 'package:portal_remoto/domain/repositories/localization_repository.dart';
import 'package:portal_remoto/domain/use_cases/character/get_character_by_id_use_case.dart';
import 'package:portal_remoto/domain/use_cases/character/search_characters_use_case.dart';
import 'package:portal_remoto/domain/use_cases/load_use_case.dart';
import 'package:portal_remoto/flavors/flavors.dart';
import 'package:portal_remoto/presentation/states/localization_state_impl.dart';

final di = ProviderContainer();

//#region ------------- apis -------------------------//
final rickAndMortyApiProvider = Provider<RestApi>((ref) => RickAndMortyApi());
//#endregion apis

//#region ------------- repositories -------------------------//
final localizationRepositoryProvider = Provider<LocalizationRepository>(
  (ref) => LocalizationRepositoryImpl(),
);
final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => switch (F.appFlavor) {
    Flavor.mock => CharacterRepositoryMock(),
    Flavor.dev || Flavor.prod => CharacterRepositoryImpl(),
  },
);
//#endregion repositories

//#region ------------- States -------------------------//
final localizationStateProvider =
    NotifierProvider<LocalizationStateImpl, Map<String, String>>(
      LocalizationStateImpl.new,
    );
//#endregion ---------- States ------------------------//

//#region ------------- use cases -------------------------//
final loadUseCaseProvider = Provider<LoadUseCase>(
  (ref) => LoadUseCase(
    localizationState: ref.read(localizationStateProvider.notifier),
  ),
);
//#region ------------- character -------------------------//
final searchCharactersUseCaseProvider = Provider<SearchCharactersUseCase>(
  (ref) => SearchCharactersUseCase(
    characterRepository: ref.read(characterRepositoryProvider),
  ),
);
final getCharacterByIdUseCaseProvider = Provider<GetCharacterByIdUseCase>(
  (ref) => GetCharacterByIdUseCase(
    characterRepository: ref.read(characterRepositoryProvider),
  ),
);
//#endregion ---------- character -------------------------//
//#endregion ---------- use cases -------------------------//
