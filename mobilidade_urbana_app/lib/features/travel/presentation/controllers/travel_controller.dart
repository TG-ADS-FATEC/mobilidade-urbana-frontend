import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';

/// Destino selecionado (nome + endereço).
final travelDestinationProvider = StateProvider<FavoriteEntity?>((ref) => null);

/// Coordenadas do destino — preenchido pela busca para evitar geocoding duplo.
final travelDestinationLatLngProvider = StateProvider<LatLng?>((ref) => null);
