abstract class LocalizationRepository {
  Future<Map<String, String>> getTranslations(String locale);
}
