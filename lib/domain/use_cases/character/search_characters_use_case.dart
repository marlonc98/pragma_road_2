import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/domain/repositories/character_repository.dart';
import 'package:remote_data_kit/remote_data_kit.dart' hide CharacterRepository;

class SearchCharactersUseCase {
  final CharacterRepository characterRepository;

  SearchCharactersUseCase({required this.characterRepository});

  Future<AsyncValue<SearchResult<CharacterEntity>>> searchCharacters({
    required int page,
    String? query,
  }) => characterRepository.searchCharacters(page: page, query: query?.trim());
}
