import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilidade_urbana_app/features/travel/presentation/controllers/travel_controller.dart';
import 'package:mobilidade_urbana_app/navigation_menu.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';
import 'package:mobilidade_urbana_app/utils/helpers/helper_functions.dart';

// ── Modelo interno de sugestão ───────────────────────────────────────────────

class _Suggestion {
  final String primary;
  final String secondary;
  final double lat;
  final double lon;

  const _Suggestion({
    required this.primary,
    required this.secondary,
    required this.lat,
    required this.lon,
  });

  static _Suggestion fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};

    final primary = (address['road'] as String?) ??
        (address['amenity'] as String?) ??
        (address['leisure'] as String?) ??
        (json['display_name'] as String).split(',').first.trim();

    final houseNumber = address['house_number'] as String?;
    final suburb = (address['suburb'] as String?) ??
        (address['neighbourhood'] as String?) ??
        (address['quarter'] as String?);
    final city = (address['city'] as String?) ??
        (address['town'] as String?) ??
        (address['municipality'] as String?);
    final state = address['state'] as String?;

    final secondaryParts = <String>[];
    if (houseNumber != null) secondaryParts.add(houseNumber);
    if (suburb != null) secondaryParts.add(suburb);
    if (city != null) secondaryParts.add(city);
    if (state != null) secondaryParts.add(state);

    return _Suggestion(
      primary: houseNumber != null ? '$primary, $houseNumber' : primary,
      secondary: secondaryParts.skip(houseNumber != null ? 1 : 0).join(', '),
      lat: double.parse(json['lat'] as String),
      lon: double.parse(json['lon'] as String),
    );
  }
}

// ── Tela ─────────────────────────────────────────────────────────────────────

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  Timer? _debounce;

  List<_Suggestion> _suggestions = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final query = _controller.text.trim();

    if (query.length < 3) {
      _debounce?.cancel();
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() => _isSearching = true);

    try {
      final response = await Dio().get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 6,
          'addressdetails': 1,
          'accept-language': 'pt-BR',
        },
        options: Options(
          headers: {'User-Agent': 'MobilidadeUrbanaApp/1.0'},
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      if (!mounted) return;

      final results = (response.data as List)
          .map((json) => _Suggestion.fromJson(json as Map<String, dynamic>))
          .toList();

      setState(() => _suggestions = results);
    } catch (_) {
      if (mounted) setState(() => _suggestions = []);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _onSuggestionTapped(_Suggestion suggestion) {
    final destination = FavoriteEntity(
      favoriteName: suggestion.primary,
      address: suggestion.secondary.isNotEmpty
          ? '${suggestion.primary}, ${suggestion.secondary}'
          : suggestion.primary,
    );

    ref.read(travelDestinationProvider.notifier).state = destination;
    ref.read(travelDestinationLatLngProvider.notifier).state =
        LatLng(suggestion.lat, suggestion.lon);
    ref.read(navigationMenuProvider.notifier).onTabChanged(1);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final bg = isDark ? TColors.darkBackground : TColors.background;
    final surface = isDark ? TColors.darkSurface : TColors.surface;
    final iconColor = isDark ? TColors.white : TColors.darkGrey;
    final query = _controller.text.trim();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Campo de busca ───────────────────────────────────────────────
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: TSizes.sm),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius:
                          BorderRadius.circular(TSizes.cardRadiusLg),
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
                              hintStyle:
                                  Theme.of(context).textTheme.bodySmall,
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

            // ── Resultados ───────────────────────────────────────────────────
            Expanded(
              child: _buildBody(context, isDark, query),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isDark, String query) {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (query.length >= 3 && _suggestions.isEmpty) {
      return Center(
        child: Text(
          'Nenhum resultado encontrado',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? TColors.darkTextSecondary
                    : TColors.textSecondary,
              ),
        ),
      );
    }

    if (_suggestions.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.xs),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 56,
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.06),
        ),
        itemBuilder: (context, index) {
          final s = _suggestions[index];
          return _SuggestionTile(
            suggestion: s,
            isDark: isDark,
            onTap: () => _onSuggestionTapped(s),
          );
        },
      );
    }

    return Center(
      child: Text(
        'Digite um destino',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? TColors.darkTextSecondary
                  : TColors.textSecondary,
            ),
      ),
    );
  }
}

// ── Tile de sugestão ─────────────────────────────────────────────────────────

class _SuggestionTile extends StatelessWidget {
  final _Suggestion suggestion;
  final bool isDark;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.suggestion,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.xs,
          vertical: TSizes.sm,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? TColors.darkSurface : TColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 20,
                color: isDark ? TColors.white : TColors.darkGrey,
              ),
            ),
            const SizedBox(width: TSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.primary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (suggestion.secondary.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      suggestion.secondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? TColors.darkTextSecondary
                                : TColors.textSecondary,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Botão de limpar ───────────────────────────────────────────────────────────

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
      child:
          const Icon(Icons.close, size: TSizes.iconMd, color: TColors.grey),
    );
  }
}
