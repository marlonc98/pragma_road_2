import 'package:flutter/material.dart';
import 'package:portal_remoto/presentation/pages/character_detail/character_detail_page_screen.dart';
import 'package:portal_remoto/presentation/pages/character_detail/character_detail_page_view_model.dart';
import 'package:portal_remoto/presentation/pages/character_detail/core/stf_view_model_adapter.dart';

class CharacterDetailPage extends StatefulWidget {
  static const String route = '/characters/:id';
  static String path(int id) => '/characters/$id';

  final int id;
  const CharacterDetailPage({super.key, required this.id});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  @override
  Widget build(BuildContext context) {
    return StfViewModelAdapter(
      create: (ref) => CharacterDetailPageViewModel(
        context: context,
        widget: widget,
        ref: ref,
        isMounted: () => mounted,
      ),
      builder: (context, viewModel) => CharacterDetailPageScreen(vm: viewModel),
    );
  }
}
