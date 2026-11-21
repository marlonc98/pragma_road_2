import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:remote_data_kit/remote_data_kit.dart';
import 'package:portal_remoto/presentation/pages/character_detail/character_detail_page.dart';
import 'package:portal_remoto/presentation/pages/character_detail/core/view_model.dart';

class CharacterDetailPageViewModel extends ViewModel<CharacterDetailPage> {
  CharacterDetailPageViewModel({
    required super.context,
    required super.widget,
    required super.ref,
    required super.isMounted,
  }) {
    handleLoadCharacter();
  }

  AsyncValue<CharacterEntity> character = const AsyncLoading();

  Future<void> handleLoadCharacter() async {
    character = const AsyncLoading();
    notifyListeners();
    final result = await ref
        .read(getCharacterByIdUseCaseProvider)
        .getCharacterById(widget.id);
    if (!mounted) return;
    character = result;
    notifyListeners();
  }
}
