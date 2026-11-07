import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/presentation/constants/text_constants.dart';
import 'package:portal_remoto/presentation/pages/characters/characters_page_view_model.dart';
import 'package:portal_remoto/presentation/pages/characters/widgets/character_card_widget.dart';
import 'package:portal_remoto/presentation/widgets/inputs/search_bar_widget.dart';
import 'package:portal_remoto/presentation/widgets/loaders_status/error_loading_widget.dart';
import 'package:portal_remoto/presentation/widgets/loaders_status/loading_widget.dart';
import 'package:portal_remoto/presentation/widgets/loaders_status/no_results_widget.dart';

class CharactersPageScreen extends ConsumerWidget {
  final CharactersPageViewModel vm;
  const CharactersPageScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localizationStateProvider);
    final i18n = ref.read(localizationStateProvider.notifier).translate;
    return Scaffold(
      appBar: AppBar(title: Text(i18n(TextConstants.charactersPageTitle))),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SearchBarWidget(
                controller: vm.searchController,
                hintText: i18n(TextConstants.charactersSearchHint),
                onChanged: vm.handleSearchChanged,
                onClear: vm.handleClearSearch,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: vm.handleReload,
                child: PagingListener<int, CharacterEntity>(
                  controller: vm.pagingController,
                  builder: (context, state, fetchNextPage) =>
                      PagedGridView<int, CharacterEntity>(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        state: state,
                        fetchNextPage: fetchNextPage,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              mainAxisExtent: CharacterCardWidget.height,
                            ),
                        builderDelegate:
                            PagedChildBuilderDelegate<CharacterEntity>(
                              itemBuilder: (context, character, index) =>
                                  CharacterCardWidget(
                                    character: character,
                                    onTap: () =>
                                        vm.handleOpenCharacter(character),
                                  ),
                              firstPageProgressIndicatorBuilder: (context) =>
                                  const LoadingWidget(),
                              firstPageErrorIndicatorBuilder: (context) =>
                                  ErrorLoadingWidget(
                                    onRetry: vm.handleReload,
                                    error: state.error?.toString(),
                                  ),
                              noItemsFoundIndicatorBuilder: (context) =>
                                  _buildEmpty(i18n),
                            ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(
    String Function(String, {Map<String, dynamic>? values}) i18n,
  ) {
    final isSearching = vm.query.isNotEmpty;
    return NoResultsWidget(
      message: i18n(
        isSearching
            ? TextConstants.charactersNoResults
            : TextConstants.charactersEmpty,
      ),
      icon: Builder(
        builder: (context) => Icon(
          isSearching ? Icons.search_off : Icons.public_off,
          size: 50,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      onRetry: isSearching ? vm.handleClearSearch : vm.handleReload,
      retryText: isSearching ? i18n(TextConstants.charactersClearSearch) : null,
    );
  }
}
