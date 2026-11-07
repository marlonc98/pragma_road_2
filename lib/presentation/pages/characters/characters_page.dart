import 'package:flutter/material.dart';
import 'package:portal_remoto/presentation/pages/characters/characters_page_screen.dart';
import 'package:portal_remoto/presentation/pages/characters/characters_page_view_model.dart';
import 'package:portal_remoto/presentation/pages/character_detail/core/stf_view_model_adapter.dart';

class CharactersPage extends StatefulWidget {
  static const String route = '/characters';
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  @override
  Widget build(BuildContext context) {
    return StfViewModelAdapter(
      create: (ref) => CharactersPageViewModel(
        context: context,
        widget: widget,
        ref: ref,
        isMounted: () => mounted,
      ),
      builder: (context, viewModel) => CharactersPageScreen(vm: viewModel),
    );
  }
}
