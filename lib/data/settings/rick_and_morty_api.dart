import 'package:portal_remoto/data/settings/rest_api.dart';

class RickAndMortyApi extends RestApi {
  RickAndMortyApi({super.client})
    : super(hostUrl: "https://rickandmortyapi.com/api");
}
