import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/data/repositories/localization/localization_repository_impl.dart';
import 'package:portal_remoto/domain/repositories/localization_repository.dart';
import 'package:portal_remoto/domain/use_cases/load_use_case.dart';
import 'package:portal_remoto/presentation/states/localization_state_impl.dart';

//#region ------------- repositories -------------------------//
final localizationRepositoryProvider = Provider<LocalizationRepository>(
  (ref) => LocalizationRepositoryImpl(),
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
//#endregion ---------- use cases -------------------------//
