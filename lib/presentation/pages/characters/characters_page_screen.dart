import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/presentation/constants/text_constants.dart';
import 'package:portal_remoto/presentation/pages/characters/characters_page_view_model.dart';
import 'package:portal_remoto/presentation/pages/characters/widgets/character_card_widget.dart';
import 'package:portal_remoto/presentation/widgets/inputs/search_bar_widget.dart';
import 'package:portal_remoto/presentation/widgets/loaders_status/error_loading_widget.dart';
import 'package:portal_remoto/presentation/widgets/loaders_status/loading_widget.dart';
import 'package:portal_remoto/presentation/widgets/loaders_status/no_results_widget.dart';

typedef _Translate = String Function(String, {Map<String, dynamic>? values});

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
              child: vm.characters.when(
                data: (characters) => characters.isEmpty
                    ? _buildEmpty(i18n)
                    : _buildGrid(i18n, characters),
                loading: () => const LoadingWidget(),
                error: (error, _) => ErrorLoadingWidget(
                  error: i18n(error.toString()),
                  onRetry: vm.handleReload,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(_Translate i18n, List<CharacterEntity> characters) {
    return RefreshIndicator(
      onRefresh: vm.handleReload,
      child: CustomScrollView(
        controller: vm.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverGrid.builder(
              itemCount: characters.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: CharacterCardWidget.height,
              ),
              itemBuilder: (context, index) => CharacterCardWidget(
                character: characters[index],
                onTap: () => vm.handleOpenCharacter(characters[index]),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildFooter(i18n)),
        ],
      ),
    );
  }

  Widget _buildFooter(_Translate i18n) {
    if (vm.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: ErrorLoadingWidget(
          error: i18n(vm.loadMoreError.toString()),
          onRetry: vm.handleLoadNextPage,
        ),
      );
    }
    if (!vm.hasMorePages) return const SizedBox(height: 24);
    return const Padding(
      padding: EdgeInsets.only(bottom: 32),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmpty(_Translate i18n) {
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
