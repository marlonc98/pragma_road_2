import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/entities/petition_status_entity.dart';
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

  AsyncState<CharacterEntity> character =
      AsyncState<CharacterEntity>.loading();

  Future<void> handleLoadCharacter() async {
    character = AsyncState<CharacterEntity>.loading();
    notifyListeners();
    final response = await ref
        .read(getCharacterByIdUseCaseProvider)
        .getCharacterById(widget.id);
    if (!mounted) return;
    character = response;
    notifyListeners();
  }
}
