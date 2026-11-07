import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portal_remoto/dependency_injection.dart';
import 'package:portal_remoto/domain/entities/character_entity.dart';
import 'package:portal_remoto/presentation/constants/text_constants.dart';
import 'package:portal_remoto/presentation/utils/character_labels.dart';
import 'package:portal_remoto/presentation/widgets/images/image_network_with_load_widget.dart';

class CharacterCardWidget extends ConsumerWidget {
  static const double height = 270;
  static const double imageHeight = 155;

  final CharacterEntity character;
  final VoidCallback? onTap;
  const CharacterCardWidget({super.key, required this.character, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localizationStateProvider);
    final i18n = ref.read(localizationStateProvider.notifier).translate;
    final textTheme = Theme.of(context).textTheme;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    final status = i18n(character.status.textKey);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'character_image_${character.id}',
              child: ImageNetworkWithLoadWidget(
                character.image,
                height: imageHeight,
                width: double.infinity,
                useCache: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: character.status.color,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          character.species.isEmpty
                              ? status
                              : '$status - ${character.species}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    i18n(TextConstants.characterDetailLocation),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(color: mutedColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    character.locationName ??
                        i18n(TextConstants.characterUnknownPlace),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
