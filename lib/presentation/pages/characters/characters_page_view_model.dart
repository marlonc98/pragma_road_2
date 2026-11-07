import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/constants/errors_constants.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/presentation/pages/character_detail/character_detail_page.dart';
import 'package:portal_remoto/presentation/pages/characters/characters_page.dart';
import 'package:portal_remoto/presentation/utils/functions_helper.dart';
import 'package:portal_remoto/presentation/utils/view_model.dart';

class CharactersPageViewModel extends ViewModel<CharactersPage> {
  CharactersPageViewModel({
    required super.context,
    required super.widget,
    required super.ref,
    required super.isMounted,
  });

  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounce;
  int _lastPage = 1;

  late final PagingController<int, CharacterEntity> pagingController =
      PagingController(getNextPageKey: _getNextPageKey, fetchPage: _fetchPage);

  String get query => searchController.text.trim();

  Future<void> handleReload() async {
    pagingController.refresh();
  }

  int? _getNextPageKey(PagingState<int, CharacterEntity> state) {
    final lastLoadedPage = state.keys?.lastOrNull;
    if (lastLoadedPage != null && lastLoadedPage >= _lastPage) return null;
    return state.nextIntPageKey;
  }

  Future<List<CharacterEntity>> _fetchPage(int page) async {
    final response = await ref
        .read(searchCharactersUseCaseProvider)
        .searchCharacters(page: page, query: query);
    if (!response.isSuccess) {
      final i18n = ref.read(localizationStateProvider.notifier).translate;
      throw i18n(response.error ?? ErrorsConstants.errorGettingCharacters);
    }
    _lastPage = response.data?.lastpage ?? page;
    return response.data?.data ?? [];
  }

  void handleSearchChanged(String _) {
    notifyListeners();
    _searchDebounce = FunctionsHelper.resetSearch(
      searchFunction: handleReload,
      timer: _searchDebounce,
    );
  }

  void handleClearSearch() {
    searchController.clear();
    handleSearchChanged('');
  }

  void handleOpenCharacter(CharacterEntity character) {
    FocusManager.instance.primaryFocus?.unfocus();
    context.push(CharacterDetailPage.path(character.id));
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    pagingController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
