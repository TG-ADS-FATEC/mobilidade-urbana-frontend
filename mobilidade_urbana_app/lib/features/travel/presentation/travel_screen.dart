import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/travel/presentation/controllers/travel_controller.dart';
import 'package:mobilidade_urbana_app/features/profile/domain/entities/preferences_entity.dart';
import 'package:mobilidade_urbana_app/features/travel/presentation/widgets/travel_preferences_bottom_sheet.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';

class TravelScreen extends ConsumerStatefulWidget {
  final FavoriteEntity? destination;
  final VoidCallback? onBack;

  const TravelScreen({super.key, this.destination, this.onBack});

  @override
  ConsumerState<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends ConsumerState<TravelScreen> {
  final MapController _mapController = MapController();

  LatLng? _userLocation;
  LatLng? _destinationLatLng;
  String? _originAddress;
  String? _destinationAddress;
  bool _locating = false;
  bool _isLoadingRoute = false;
  bool _pendingRoute = false;
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
    if (widget.destination != null) {
      final addr = widget.destination!.address ?? widget.destination!.favoriteName;
      _destinationAddress = addr;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final preloaded = ref.read(travelDestinationLatLngProvider);
        if (preloaded != null) {
          setState(() => _destinationLatLng = preloaded);
        } else {
          _geocodeAddress(addr).then((latLng) {
            if (mounted) setState(() => _destinationLatLng = latLng);
          });
        }
      });
    }
  }

  void _swapAddresses() {
    setState(() {
      final tmpAddress = _originAddress;
      _originAddress = _destinationAddress;
      _destinationAddress = tmpAddress;

      final tmpLatLng = _userLocation;
      _userLocation = _destinationLatLng;
      _destinationLatLng = tmpLatLng;

      _routePoints = [];
    });
  }

  Future<void> _loadUserLocation() async {
    setState(() {
      _locating = true;
      _originAddress = null;
    });

    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final latLng = LatLng(position.latitude, position.longitude);
      if (!mounted) return;

      setState(() => _userLocation = latLng);
      _mapController.move(latLng, 15);

      final address =
          await _reverseGeocode(position.latitude, position.longitude);
      if (mounted) setState(() => _originAddress = address);

      if (_pendingRoute && _destinationLatLng != null) {
        _pendingRoute = false;
        _fetchRoute();
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<String?> _reverseGeocode(double lat, double lon) async {
    try {
      final response = await Dio().get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lon,
          'addressdetails': 1,
        },
        options: Options(
          headers: {'User-Agent': 'MobilidadeUrbanaApp/1.0'},
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      final address = (response.data as Map<String, dynamic>)['address']
          as Map<String, dynamic>?;
      if (address == null) return null;

      final road = address['road'] as String?;
      final number = address['house_number'] as String?;
      final suburb = address['suburb'] as String? ??
          address['neighbourhood'] as String?;

      final parts = <String>[];
      if (road != null) parts.add(number != null ? '$road, $number' : road);
      if (suburb != null) parts.add(suburb);

      return parts.isNotEmpty ? parts.join(' — ') : null;
    } catch (_) {
      return null;
    }
  }

  Future<LatLng?> _geocodeAddress(String address) async {
    try {
      final response = await Dio().get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': address,
          'format': 'json',
          'limit': 1,
        },
        options: Options(
          headers: {'User-Agent': 'MobilidadeUrbanaApp/1.0'},
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      final results = response.data as List;
      if (results.isEmpty) return null;

      final lat = double.parse(results[0]['lat'] as String);
      final lon = double.parse(results[0]['lon'] as String);
      return LatLng(lat, lon);
    } catch (_) {
      return null;
    }
  }

  Future<void> _fetchRoute() async {
    if (_userLocation == null || _destinationLatLng == null) return;

    setState(() {
      _isLoadingRoute = true;
      _routePoints = [];
    });

    try {
      final origin = _userLocation!;
      final dest = _destinationLatLng!;

      final response = await Dio().get(
        'http://router.project-osrm.org/route/v1/driving/'
        '${origin.longitude},${origin.latitude};'
        '${dest.longitude},${dest.latitude}',
        queryParameters: {
          'overview': 'full',
          'geometries': 'geojson',
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      final routes =
          (response.data as Map<String, dynamic>)['routes'] as List;
      if (routes.isEmpty) return;

      final coordinates =
          routes[0]['geometry']['coordinates'] as List;
      final points = coordinates
          .map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();

      if (!mounted) return;
      setState(() => _routePoints = points);

      if (points.isNotEmpty) {
        final bounds = LatLngBounds.fromPoints(points);
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(60),
          ),
        );
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<FavoriteEntity?>(travelDestinationProvider, (_, next) {
      if (next != null) {
        final addr = next.address ?? next.favoriteName;
        final preloaded = ref.read(travelDestinationLatLngProvider);
        setState(() {
          _destinationAddress = addr;
          _routePoints = [];
          _destinationLatLng = preloaded;
        });
        if (preloaded != null) {
          if (_userLocation != null) {
            _fetchRoute();
          } else {
            _pendingRoute = true;
          }
        } else {
          _geocodeAddress(addr).then((latLng) {
            if (!mounted) return;
            setState(() => _destinationLatLng = latLng);
            if (latLng != null) {
              if (_userLocation != null) {
                _fetchRoute();
              } else {
                _pendingRoute = true;
              }
            }
          });
        }
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(-23.5505, -46.6333),
              initialZoom: 15,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.pinchZoom |
                    InteractiveFlag.drag |
                    InteractiveFlag.doubleTapZoom,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.mobilidade.urbana',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Colors.blue.shade600,
                      strokeWidth: 5,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (_userLocation != null)
                    Marker(
                      point: _userLocation!,
                      width: 28,
                      height: 28,
                      child: const _UserLocationMarker(),
                    ),
                  if (_destinationLatLng != null)
                    Marker(
                      point: _destinationLatLng!,
                      width: 32,
                      height: 32,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 32,
                      ),
                    ),
                ],
              ),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _BackButton(onBack: widget.onBack),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 340,
            child: _RecenterButton(
              loading: _locating,
              onTap: _loadUserLocation,
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _RoutePanel(
              originAddress: _originAddress,
              destinationAddress: _destinationAddress,
              locating: _locating,
              isLoadingRoute: _isLoadingRoute,
              canFindRoute: _userLocation != null && _destinationLatLng != null,
              onSwap: _swapAddresses,
              onFindRoute: _fetchRoute,
              onPreferences: () => showTravelPreferencesSheet(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Botões flutuantes ────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback? onBack;
  const _BackButton({this.onBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBack ?? () => Navigator.maybePop(context),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.black87,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
      ),
    );
  }
}

class _RecenterButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;
  const _RecenterButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.my_location, size: 20, color: Colors.black87),
      ),
    );
  }
}

// ── Marcador de localização ──────────────────────────────────────────────────

class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

// ── Painel inferior ──────────────────────────────────────────────────────────

class _RoutePanel extends StatelessWidget {
  final String? originAddress;
  final String? destinationAddress;
  final bool locating;
  final bool isLoadingRoute;
  final bool canFindRoute;
  final VoidCallback onSwap;
  final VoidCallback onFindRoute;
  final VoidCallback onPreferences;

  const _RoutePanel({
    required this.originAddress,
    required this.destinationAddress,
    required this.locating,
    required this.isLoadingRoute,
    required this.canFindRoute,
    required this.onSwap,
    required this.onFindRoute,
    required this.onPreferences,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? TColors.darkBackground : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Para onde vamos hoje?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _PreferencesButton(isDark: isDark, onTap: onPreferences),
                const SizedBox(height: 16),
                _SearchCard(
                  isDark: isDark,
                  originAddress: originAddress,
                  destinationAddress: destinationAddress,
                  locating: locating,
                  onSwap: onSwap,
                ),
                const SizedBox(height: 16),
                _FindButton(
                  loading: isLoadingRoute,
                  enabled: canFindRoute,
                  onPressed: onFindRoute,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferencesButton extends ConsumerWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _PreferencesButton({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(travelPreferencesProvider);

    final labels = {
      RoutePreference.fastest: 'Mais rápida',
      RoutePreference.fewerTransfers: 'Menos trocas',
      RoutePreference.leastWalking: 'Caminhar menos',
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.15),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labels[prefs.routePreference] ?? 'Preferências de trajeto',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? TColors.darkTextSecondary : TColors.textSecondary,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: isDark ? TColors.darkTextSecondary : TColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  final bool isDark;
  final String? originAddress;
  final String? destinationAddress;
  final bool locating;
  final VoidCallback onSwap;

  const _SearchCard({
    required this.isDark,
    required this.originAddress,
    required this.destinationAddress,
    required this.locating,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? TColors.darkBackground : TColors.lightGrey,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _OriginField(
                isDark: isDark,
                address: originAddress,
                locating: locating,
              ),
              Divider(
                height: 1,
                indent: 56,
                endIndent: 56,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.08),
              ),
              _DestinationField(
                isDark: isDark,
                address: destinationAddress,
              ),
            ],
          ),
        ),
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: onSwap,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark ? TColors.darkBackground : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.swap_vert,
                  size: 18,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OriginField extends StatelessWidget {
  final bool isDark;
  final String? address;
  final bool locating;

  const _OriginField({
    required this.isDark,
    required this.address,
    required this.locating,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              Icons.radio_button_checked_outlined,
              color: isDark ? Colors.white70 : Colors.black87,
              size: 22,
            ),
            const SizedBox(width: 16),
            if (locating && address == null) ...[
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isDark ? Colors.white54 : Colors.black38,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Obtendo localização...',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ] else ...[
              Expanded(
                child: Text(
                  address ?? 'Seu local',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: address != null
                        ? (isDark ? Colors.white : TColors.textPrimary)
                        : (isDark
                            ? TColors.darkTextSecondary
                            : TColors.textSecondary),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DestinationField extends StatelessWidget {
  final bool isDark;
  final String? address;

  const _DestinationField({required this.isDark, required this.address});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                address ?? 'Informe o destino',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: address != null
                      ? (isDark ? Colors.white : TColors.textPrimary)
                      : (isDark
                          ? TColors.darkTextSecondary
                          : TColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FindButton extends StatelessWidget {
  final bool loading;
  final bool enabled;
  final VoidCallback onPressed;

  const _FindButton({
    required this.loading,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black54,
                ),
              )
            : const Icon(Icons.search, size: 20),
        label: Text(
          loading ? 'Calculando rota...' : 'Encontrar seu caminho',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: TColors.soothingLime,
          foregroundColor: TColors.textPrimary,
          disabledBackgroundColor: TColors.soothingLime.withValues(alpha: 0.5),
          disabledForegroundColor: TColors.textPrimary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        onPressed: (loading || !enabled) ? null : onPressed,
      ),
    );
  }
}
