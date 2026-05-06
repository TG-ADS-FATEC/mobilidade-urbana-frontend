import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final bg = isDark ? TColors.darkBackground : TColors.background;
    final surface = isDark ? TColors.darkSurface : TColors.surface;
    final iconColor = isDark ? TColors.white : TColors.darkGrey;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Search field — mesmo Hero tag do TSearchContainer
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.xs,
                vertical: TSizes.sm,
              ),
              child: Hero(
                tag: 'search-bar',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    height: TSizes.buttonHeight * 1.25,
                    padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.arrow_back,
                            color: iconColor,
                            size: TSizes.iconMd,
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              hintText: 'Para onde você quer ir?',
                              border: InputBorder.none,
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                        _ClearButton(controller: _controller),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Área de resultados (futura)
            Expanded(
              child: Center(
                child: Text(
                  'Digite um destino',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? TColors.darkTextSecondary
                            : TColors.textSecondary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botão de limpar que aparece quando há texto
class _ClearButton extends StatefulWidget {
  const _ClearButton({required this.controller});
  final TextEditingController controller;

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.text.isEmpty) return const SizedBox.shrink();
    return GestureDetector(
      onTap: widget.controller.clear,
      child: const Icon(Icons.close, size: TSizes.iconMd, color: TColors.grey),
    );
  }
}
