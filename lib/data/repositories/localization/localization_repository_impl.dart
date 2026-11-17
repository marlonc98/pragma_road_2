import 'package:portal_remoto/data/repositories/localization/api/get_translations_api_impl.dart';
import 'package:portal_remoto/domain/repositories/localization_repository.dart';

class LocalizationRepositoryImpl extends LocalizationRepository {
  @override
  Future<Map<String, String>> getTranslations(String locale) =>
      getTranslationsApiImpl(locale);
}
