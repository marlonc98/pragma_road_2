import 'dart:convert';

import 'package:portal_remoto/data/dtos/character_dto.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/entities/search_result_entity.dart';

Future<SearchResultEntity<CharacterEntity>> searchCharactersApiImpl({
  required int page,
  required int itemsPerPage,
  String? query,
}) async {
  final String responseText;
  try {
    responseText = await di
        .read(rickAndMortyApiProvider)
        .get(
          '/character',
          query: {
            'page': '$page',
            if (query != null && query.isNotEmpty) 'name': query,
          },
        );
  } catch (error) {
    if (error == ErrorsConstants.notFound) {
      return SearchResultEntity.empty(
        currentPage: page,
        itemsPerPage: itemsPerPage,
      );
    }
    rethrow;
  }
  final Map<String, dynamic> json = jsonDecode(responseText);
  final List<dynamic> results = json['results'] ?? [];
  return SearchResultEntity(
    currentPage: page,
    totalItems: json['info']?['count'] ?? results.length,
    data: results.map((item) => CharacterDto.fromJSON(item)).toList(),
    itemsPerPage: itemsPerPage,
    lastpage: json['info']?['pages'] ?? page,
  );
}
