import 'package:flutter/material.dart';

enum LineType { bus, metro, train }

class TransitLine {
  final String code;
  final String name;
  final LineType type;
  final Color color;
  final bool isFavorite;

  const TransitLine({
    required this.code,
    required this.name,
    required this.type,
    required this.color,
    this.isFavorite = false,
  });
}
