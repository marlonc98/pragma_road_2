import 'package:portal_remoto/data/settings/rest_api.dart';

class RickAndMortyApi extends RestApi {
  static final RickAndMortyApi _instance = RickAndMortyApi._();

  factory RickAndMortyApi() => _instance;

  RickAndMortyApi._() : super(hostUrl: "https://rickandmortyapi.com/api");
}
