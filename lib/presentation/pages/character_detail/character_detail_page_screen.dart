import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/presentation/constants/text_constants.dart';
import 'package:portal_remoto/presentation/pages/character_detail/character_detail_page_view_model.dart';
import 'package:portal_remoto/presentation/pages/character_detail/widgets/character_info_row_widget.dart';
import 'package:portal_remoto/presentation/utils/character_labels.dart';
import 'package:portal_remoto/presentation/widgets/images/image_network_with_load_widget.dart';
import 'package:portal_remoto/presentation/widgets/loaders_status/loader_screen_widget.dart';

typedef _Translate = String Function(String, {Map<String, dynamic>? values});

class CharacterDetailPageScreen extends ConsumerWidget {
  final CharacterDetailPageViewModel vm;
  const CharacterDetailPageScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localizationStateProvider);
    final i18n = ref.read(localizationStateProvider.notifier).translate;
    final overImage = vm.character.isSuccess;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: overImage ? Colors.white : null,
        systemOverlayStyle: overImage ? SystemUiOverlayStyle.light : null,
      ),
      body: LoaderScreenWidget<CharacterEntity>(
        status: vm.character,
        onRetry: vm.handleLoadCharacter,
        builder: (context, character) =>
            _buildCharacter(context, i18n, character),
      ),
    );
  }

  Widget _buildCharacter(
    BuildContext context,
    _Translate i18n,
    CharacterEntity character,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildHeader(context, character),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: character.status.color),
                  const SizedBox(width: 8),
                  Text(
                    i18n(character.status.textKey),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(i18n, character),
              const SizedBox(height: 24),
              Text(
                i18n(TextConstants.characterDetailSummary),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _summary(i18n, character),
                style: textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, CharacterEntity character) {
    final height = MediaQuery.of(context).size.height * 0.45;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'character_image_${character.id}',
            child: ImageNetworkWithLoadWidget(
              character.image,
              height: height,
              width: double.infinity,
              useCache: true,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.25, 0.6, 1],
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0),
                  Colors.black.withValues(alpha: 0),
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Text(
              character.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(_Translate i18n, CharacterEntity character) {
    final unknownPlace = i18n(TextConstants.characterUnknownPlace);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            if (character.species.isNotEmpty)
              CharacterInfoRowWidget(
                title: i18n(TextConstants.characterDetailSpecies),
                value: character.species,
              ),
            if (character.hasType)
              CharacterInfoRowWidget(
                title: i18n(TextConstants.characterDetailType),
                value: character.type!,
              ),
            CharacterInfoRowWidget(
              title: i18n(TextConstants.characterDetailGender),
              value: i18n(character.gender.textKey),
            ),
            CharacterInfoRowWidget(
              title: i18n(TextConstants.characterDetailOrigin),
              value: character.originName ?? unknownPlace,
            ),
            CharacterInfoRowWidget(
              title: i18n(TextConstants.characterDetailLocation),
              value: character.locationName ?? unknownPlace,
            ),
            CharacterInfoRowWidget(
              title: i18n(TextConstants.characterDetailId),
              value: '${character.id}',
            ),
          ],
        ),
      ),
    );
  }

  String _summary(_Translate i18n, CharacterEntity character) => i18n(
    TextConstants.characterDetailSummaryText,
    values: {
      'name': character.name,
      'species': character.species.isEmpty
          ? i18n(TextConstants.characterStatusUnknown).toLowerCase()
          : character.species.toLowerCase(),
      'status': i18n(character.status.textKey).toLowerCase(),
      'gender': i18n(character.gender.textKey).toLowerCase(),
    },
  );
}
