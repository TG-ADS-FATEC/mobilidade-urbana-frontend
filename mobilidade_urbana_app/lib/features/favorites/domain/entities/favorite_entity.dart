import 'package:equatable/equatable.dart';



class FavoriteEntity extends Equatable {
  final String favoriteName;
  final String? favoriteId;
  final DateTime? createdAt;
  final String? address;

  const FavoriteEntity ({
      required this.favoriteName,
      this.favoriteId,
      this.createdAt,
      this.address,
  });

  @override
  List<Object?> get props => [
    favoriteName,
    favoriteId,
    createdAt,
    address,
  ];
}