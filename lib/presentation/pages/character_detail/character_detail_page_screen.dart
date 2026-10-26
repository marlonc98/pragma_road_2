import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/presentation/constants/text_constants.dart';
import 'package:portal_remoto/presentation/pages/character_detail/character_detail_page_view_model.dart';
import 'package:portal_remoto/presentation/pages/character_detail/widgets/character_feature_item_widget.dart';
import 'package:portal_remoto/presentation/utils/character_labels.dart';
import 'package:portal_remoto/presentation/widgets/images/image_network_with_load_widget.dart';
import 'package:portal_remoto/presentation/widgets/lists/list_item_widget.dart';
import 'package:portal_remoto/presentation/widgets/loaders_status/loader_screen_widget.dart';

class CharacterDetailPageScreen extends ConsumerWidget {
  final CharacterDetailPageViewModel vm;
  const CharacterDetailPageScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localizationStateProvider);
    final i18n = ref.read(localizationStateProvider.notifier).translate;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          vm.character.data?.name ??
              i18n(TextConstants.characterDetailDefaultTitle),
        ),
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
    String Function(String, {Map<String, dynamic>? values}) i18n,
    CharacterEntity character,
  ) {
    final unknownPlace = i18n(TextConstants.characterUnknownPlace);
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Hero(
          tag: 'character_image_${character.id}',
          child: ImageNetworkWithLoadWidget(
            character.image,
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                character.name,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CharacterFeatureItemWidget(
                      title: i18n(TextConstants.characterDetailStatus),
                      value: i18n(character.status.textKey),
                      icon: Icons.circle,
                      iconColor: character.status.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CharacterFeatureItemWidget(
                      title: i18n(TextConstants.characterDetailGender),
                      value: i18n(character.gender.textKey),
                      icon: character.gender.icon,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CharacterFeatureItemWidget(
                      title: i18n(TextConstants.characterDetailEpisodes),
                      value: '${character.episodesCount}',
                      icon: Icons.movie_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (character.species.isNotEmpty)
                ListItemWidget(
                  title: i18n(TextConstants.characterDetailSpecies),
                  value: character.species,
                ),
              if (character.hasType)
                ListItemWidget(
                  title: i18n(TextConstants.characterDetailType),
                  value: character.type,
                ),
              ListItemWidget(
                title: i18n(TextConstants.characterDetailOrigin),
                value: character.originName ?? unknownPlace,
              ),
              ListItemWidget(
                title: i18n(TextConstants.characterDetailLocation),
                value: character.locationName ?? unknownPlace,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
