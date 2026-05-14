import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';

final travelDestinationProvider = StateProvider<FavoriteEntity?>((ref) => null);
