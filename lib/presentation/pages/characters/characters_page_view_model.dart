import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/presentation/pages/character_detail/character_detail_page.dart';
import 'package:portal_remoto/presentation/pages/character_detail/core/view_model.dart';
import 'package:portal_remoto/presentation/pages/characters/characters_page.dart';
import 'package:portal_remoto/presentation/utils/functions_helper.dart';

class CharactersPageViewModel extends ViewModel<CharactersPage> {
  /// Distancia al final de la lista a la que se pide la siguiente página.
  static const double loadMoreThreshold = 400;

  CharactersPageViewModel({
    required super.context,
    required super.widget,
    required super.ref,
    required super.isMounted,
  }) {
    scrollController.addListener(_handleScroll);
    handleReload();
  }

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _searchDebounce;

  /// Primera página: loading, error o la lista acumulada.
  AsyncValue<List<CharacterEntity>> characters = const AsyncLoading();

  /// Estado de las páginas siguientes, que se muestra al final de la lista.
  bool isLoadingMore = false;
  Object? loadMoreError;

  int _page = 1;
  int _lastPage = 1;

  /// Cambia en cada búsqueda nueva para descartar respuestas que ya no aplican.
  int _request = 0;

  String get query => searchController.text.trim();

  bool get hasMorePages => _page < _lastPage;

  Future<void> handleReload() async {
    final request = ++_request;
    _page = 1;
    isLoadingMore = false;
    loadMoreError = null;
    if (!characters.hasValue) {
      characters = const AsyncLoading();
      notifyListeners();
    }
    final result = await AsyncValue.guard(() => _fetch(1, request));
    if (!mounted || request != _request) return;
    characters = result;
    notifyListeners();
  }

  Future<void> handleLoadNextPage() async {
    final current = characters.value;
    if (current == null || isLoadingMore || !hasMorePages) return;
    final request = _request;
    isLoadingMore = true;
    loadMoreError = null;
    notifyListeners();
    try {
      final next = await _fetch(_page + 1, request);
      if (!mounted || request != _request) return;
      _page++;
      characters = AsyncData([...current, ...next]);
    } catch (error) {
      if (!mounted || request != _request) return;
      loadMoreError = error;
    }
    isLoadingMore = false;
    notifyListeners();
  }

  Future<List<CharacterEntity>> _fetch(int page, int request) async {
    final result = await ref
        .read(searchCharactersUseCaseProvider)
        .searchCharacters(page: page, query: query);
    if (request == _request) _lastPage = result.lastpage;
    return result.data;
  }

  void _handleScroll() {
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - loadMoreThreshold &&
        loadMoreError == null) {
      handleLoadNextPage();
    }
  }

  void handleSearchChanged(String _) {
    notifyListeners();
    _searchDebounce = FunctionsHelper.resetSearch(
      searchFunction: () {
        characters = const AsyncLoading();
        handleReload();
      },
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
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }
}
