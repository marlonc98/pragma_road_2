import 'package:portal_remoto/domain/states/localization_state.dart';

class LoadUseCase {
  final LocalizationState localizationState;

  LoadUseCase({required this.localizationState});

  Future<void> call() async {
    await localizationState.load();
  }
}
