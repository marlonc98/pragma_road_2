import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portal_remoto/data/repositories/character/character_repository_impl.dart';
import 'package:portal_remoto/data/settings/rick_and_morty_api.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';

Map<String, dynamic> characterJson(int id, String name) => {
  'id': id,
  'name': name,
  'status': 'Alive',
  'species': 'Human',
  'gender': 'Male',
  'image': 'https://rickandmortyapi.com/api/character/avatar/$id.jpeg',
  'episode': [],
};

CharacterRepositoryImpl repositoryWith(
  Future<http.Response> Function(http.Request request) handler,
) => CharacterRepositoryImpl(api: RickAndMortyApi(client: MockClient(handler)));

void main() {
  test('busca por nombre y página y arma el SearchResultEntity', () async {
    late Uri requested;
    final repository = repositoryWith((request) async {
      requested = request.url;
      return http.Response(
        jsonEncode({
          'info': {'count': 25, 'pages': 2},
          'results': [characterJson(1, 'Rick Sanchez')],
        }),
        200,
      );
    });

    final response = await repository.searchCharacters(page: 2, query: 'rick');

    expect(requested.path, '/api/character');
    expect(requested.queryParameters, {'page': '2', 'name': 'rick'});
    expect(response.isSuccess, isTrue);
    expect(response.data!.data.single.name, 'Rick Sanchez');
    expect(response.data!.totalItems, 25);
    expect(response.data!.lastpage, 2);
  });

  test('sin texto de búsqueda no manda el parámetro name', () async {
    late Uri requested;
    final repository = repositoryWith((request) async {
      requested = request.url;
      return http.Response(jsonEncode({'info': {}, 'results': []}), 200);
    });

    await repository.searchCharacters(page: 1, query: '');

    expect(requested.queryParameters, {'page': '1'});
  });

  test('un 404 en la búsqueda es una lista vacía, no un error', () async {
    final repository = repositoryWith(
      (_) async => http.Response('{"error":"There is nothing here"}', 404),
    );

    final response = await repository.searchCharacters(page: 1, query: 'zzz');

    expect(response.isSuccess, isTrue);
    expect(response.data!.isEmpty, isTrue);
    expect(response.data!.lastpage, 0);
  });

  test(
    'un error del servidor en la búsqueda usa el error por defecto',
    () async {
      final repository = repositoryWith((_) async => http.Response('', 500));

      final response = await repository.searchCharacters(page: 1);

      expect(response.isError, isTrue);
      expect(response.error, ErrorsConstants.errorGettingCharacters);
    },
  );

  test('sin conexión devuelve noInternet', () async {
    final repository = repositoryWith(
      (_) async => throw http.ClientException('Failed host lookup'),
    );

    final response = await repository.searchCharacters(page: 1);

    expect(response.error, ErrorsConstants.noInternet);
  });

  test('obtiene un personaje por id', () async {
    final repository = repositoryWith((request) async {
      expect(request.url.path, '/api/character/2');
      return http.Response(jsonEncode(characterJson(2, 'Morty Smith')), 200);
    });

    final response = await repository.getCharacterById(2);

    expect(response.data!.name, 'Morty Smith');
  });

  test('un id que no existe da characterNotFound', () async {
    final repository = repositoryWith(
      (_) async => http.Response('{"error":"Character not found"}', 404),
    );

    final response = await repository.getCharacterById(99999);

    expect(response.isError, isTrue);
    expect(response.error, ErrorsConstants.characterNotFound);
  });
}
