import 'package:flutter/material.dart';
import 'package:mobilidade_urbana_app/core/services/auth_service.dart';
import 'package:mobilidade_urbana_app/utils/local_storage/hive_init.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveInit.init();
  await AuthService.authenticate();

  runApp(const App());
}