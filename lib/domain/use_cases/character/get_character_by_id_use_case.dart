import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/core/async_state.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';

class GetCharacterByIdUseCase {
  final CharacterRepository characterRepository;

  GetCharacterByIdUseCase({required this.characterRepository});

  Future<AsyncState<CharacterEntity>> getCharacterById(int id) =>
      characterRepository.getCharacterById(id);
}
