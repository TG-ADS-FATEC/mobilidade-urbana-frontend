import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/trip_favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/trip_favorite_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class TripFavoriteFormBottomSheet extends ConsumerStatefulWidget {
  final TripFavoriteEntity? trip;

  const TripFavoriteFormBottomSheet({super.key, this.trip});

  @override
  ConsumerState<TripFavoriteFormBottomSheet> createState() =>
      _TripFavoriteFormBottomSheetState();
}

class _TripFavoriteFormBottomSheetState
    extends ConsumerState<TripFavoriteFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _cepController;
  late final TextEditingController _addressController;

  bool _submitting = false;
  bool _cepLoading = false;
  String? _cepError;

  double? _lat;
  double? _lng;

  bool get _isEditing => widget.trip != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.trip?.name ?? '');
    _addressController = TextEditingController(text: widget.trip?.address ?? '');
    _cepController = TextEditingController();
    if (_isEditing) {
      _lat = widget.trip!.destinationLatitude;
      _lng = widget.trip!.destinationLongitude;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cepController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _onCepChanged(String value) async {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) return;

    setState(() { _cepLoading = true; _cepError = null; });

    try {
      // 1. ViaCEP → endereço legível
      final cepRes = await Dio().get('https://viacep.com.br/ws/$digits/json/');
      final cepData = cepRes.data as Map<String, dynamic>;
      if (cepData['erro'] == true) {
        setState(() => _cepError = 'CEP não encontrado');
        return;
      }

      final logradouro = cepData['logradouro'] as String? ?? '';
      final bairro = cepData['bairro'] as String? ?? '';
      final cidade = cepData['localidade'] as String? ?? '';
      final uf = cepData['uf'] as String? ?? '';
      final parts = [logradouro, bairro].where((s) => s.isNotEmpty).toList();
      final cityState = [cidade, uf].where((s) => s.isNotEmpty).join('/');
      final address = cityState.isNotEmpty
          ? '${parts.join(', ')} - $cityState'
          : parts.join(', ');
      _addressController.text = address.trim();

      // 2. Nominatim → lat/lng
      final query = [logradouro, bairro, cidade, uf, 'Brasil']
          .where((s) => s.isNotEmpty)
          .join(', ');
      final geoRes = await Dio().get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {'q': query, 'format': 'json', 'limit': 1},
        options: Options(headers: {'User-Agent': 'mobilidade-urbana-app'}),
      );
      final results = geoRes.data as List;
      if (results.isNotEmpty) {
        setState(() {
          _lat = double.tryParse(results[0]['lat'] as String);
          _lng = double.tryParse(results[0]['lon'] as String);
        });
      }
    } on DioException {
      setState(() => _cepError = 'Erro ao consultar o CEP');
    } finally {
      if (mounted) setState(() => _cepLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um CEP válido para obter a localização')),
      );
      return;
    }

    setState(() => _submitting = true);
    final notifier = ref.read(tripFavoriteProvider.notifier);
    final name = _nameController.text.trim();
    final address = _addressController.text.trim().isEmpty ? null : _addressController.text.trim();

    final bool success;
    if (_isEditing) {
      success = await notifier.updateTrip(TripFavoriteEntity(
        id: widget.trip!.id,
        name: name,
        destinationLatitude: _lat!,
        destinationLongitude: _lng!,
        createdAt: widget.trip!.createdAt,
        address: address,
      ));
    } else {
      success = await notifier.addTrip(TripFavoriteEntity(
        name: name,
        destinationLatitude: _lat!,
        destinationLongitude: _lng!,
        address: address,
      ));
    }

    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      Navigator.pop(context);
    } else {
      final error = ref.read(tripFavoriteProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Erro ao salvar destino')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: TSizes.md, right: TSizes.md, top: TSizes.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              _isEditing ? 'Editar destino' : 'Novo destino',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: TSizes.sm),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nome',
                hintText: 'Ex: Casa, Trabalho...',
                prefixIcon: const Icon(Icons.label_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe um nome' : null,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            TextFormField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CepInputFormatter(),
              ],
              onChanged: _onCepChanged,
              decoration: InputDecoration(
                labelText: 'CEP',
                hintText: '00000-000',
                prefixIcon: const Icon(Icons.pin_drop_outlined),
                suffixIcon: _cepLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : _lat != null
                        ? const Icon(Icons.check_circle, color: TColors.success, size: 20)
                        : null,
                errorText: _cepError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            TextFormField(
              controller: _addressController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Endereço',
                hintText: 'Preenchido automaticamente pelo CEP',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(TSizes.borderRadiusLg)),
              ),
            ),
            const SizedBox(height: TSizes.md),
            SizedBox(
              width: double.infinity,
              height: TSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: TColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.buttonRadius),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: TColors.white, strokeWidth: 2))
                    : Text(_isEditing ? 'Salvar alterações' : 'Adicionar destino'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) return oldValue;
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 5) buffer.write('-');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
