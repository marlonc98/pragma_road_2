import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portal_remoto/data/repositories/character/character_repository_impl.dart';
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

Future<T> withServer<T>(
  Future<http.Response> Function(http.Request request) handler,
  Future<T> Function() call,
) => http.runWithClient(call, () => MockClient(handler));

void main() {
  late CharacterRepositoryImpl repository;

  setUp(() => repository = CharacterRepositoryImpl());

  test('busca por nombre y página y arma el SearchResult', () async {
    late Uri requested;
    final response = await withServer((request) async {
      requested = request.url;
      return http.Response(
        jsonEncode({
          'info': {'count': 25, 'pages': 2},
          'results': [characterJson(1, 'Rick Sanchez')],
        }),
        200,
      );
    }, () => repository.searchCharacters(page: 2, query: 'rick'));

    expect(requested.path, '/api/character');
    expect(requested.queryParameters, {'page': '2', 'name': 'rick'});
    expect(response.isSuccess, isTrue);
    expect(response.data!.data.single.name, 'Rick Sanchez');
    expect(response.data!.totalItems, 25);
    expect(response.data!.lastpage, 2);
  });

  test('sin texto de búsqueda no manda el parámetro name', () async {
    late Uri requested;
    await withServer((request) async {
      requested = request.url;
      return http.Response(jsonEncode({'info': {}, 'results': []}), 200);
    }, () => repository.searchCharacters(page: 1, query: ''));

    expect(requested.queryParameters, {'page': '1'});
  });

  test('un 404 en la búsqueda es una lista vacía, no un error', () async {
    final response = await withServer(
      (_) async => http.Response('{"error":"There is nothing here"}', 404),
      () => repository.searchCharacters(page: 1, query: 'zzz'),
    );

    expect(response.isSuccess, isTrue);
    expect(response.data!.isEmpty, isTrue);
    expect(response.data!.lastpage, 0);
  });

  test(
    'un error del servidor en la búsqueda usa el error por defecto',
    () async {
      final response = await withServer(
        (_) async => http.Response('', 500),
        () => repository.searchCharacters(page: 1),
      );

      expect(response.isError, isTrue);
      expect(response.error, ErrorsConstants.errorGettingCharacters);
    },
  );

  test('sin conexión devuelve noInternet', () async {
    final response = await withServer(
      (_) async => throw http.ClientException('Failed host lookup'),
      () => repository.searchCharacters(page: 1),
    );

    expect(response.error, ErrorsConstants.noInternet);
  });

  test('obtiene un personaje por id', () async {
    late Uri requested;
    final response = await withServer((request) async {
      requested = request.url;
      return http.Response(jsonEncode(characterJson(2, 'Morty Smith')), 200);
    }, () => repository.getCharacterById(2));

    expect(requested.path, '/api/character/2');
    expect(response.data!.name, 'Morty Smith');
  });

  test('un id que no existe da characterNotFound', () async {
    final response = await withServer(
      (_) async => http.Response('{"error":"Character not found"}', 404),
      () => repository.getCharacterById(99999),
    );

    expect(response.isError, isTrue);
    expect(response.error, ErrorsConstants.characterNotFound);
  });

  test(
    'el detalle sale de la caché si el personaje ya vino en una búsqueda',
    () async {
      var requests = 0;
      Future<http.Response> handler(http.Request request) async {
        requests++;
        return http.Response(
          jsonEncode({
            'info': {'count': 1, 'pages': 1},
            'results': [characterJson(1, 'Rick Sanchez')],
          }),
          200,
        );
      }

      final response = await withServer(handler, () async {
        await repository.searchCharacters(page: 1);
        return repository.getCharacterById(1);
      });

      expect(requests, 1);
      expect(response.data!.name, 'Rick Sanchez');
    },
  );

  test('un detalle pedido por id queda en caché', () async {
    var requests = 0;
    await withServer(
      (_) async {
        requests++;
        return http.Response(jsonEncode(characterJson(2, 'Morty Smith')), 200);
      },
      () async {
        await repository.getCharacterById(2);
        await repository.getCharacterById(2);
      },
    );

    expect(requests, 1);
  });
}
