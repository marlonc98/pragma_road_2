import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/data/dtos/character_dto.dart';
import 'package:portal_remoto/data/settings/rest_api.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/domain/core/search_result.dart';

Future<AsyncValue<SearchResult<CharacterEntity>>> searchCharactersApiImpl(
  RestApi api, {
  required int page,
  required int itemsPerPage,
  String? query,
}) async {
  final response = await api.get(
    '/character',
    query: {
      'page': '$page',
      if (query != null && query.isNotEmpty) 'name': query,
    },
  );
  if (response case AsyncError(:final error, :final stackTrace)) {
    if (error == ErrorsConstants.notFound) {
      return AsyncData(
        SearchResult.empty(currentPage: page, itemsPerPage: itemsPerPage),
      );
    }
    return AsyncError(error, stackTrace);
  }
  return AsyncValue.guard(() async {
    final Map<String, dynamic> json = jsonDecode(response.requireValue);
    final List<dynamic> results = json['results'] ?? [];
    return SearchResult(
      currentPage: page,
      totalItems: json['info']?['count'] ?? results.length,
      data: results.map((item) => CharacterDto.fromJSON(item)).toList(),
      itemsPerPage: itemsPerPage,
      lastpage: json['info']?['pages'] ?? page,
    );
  });
}
