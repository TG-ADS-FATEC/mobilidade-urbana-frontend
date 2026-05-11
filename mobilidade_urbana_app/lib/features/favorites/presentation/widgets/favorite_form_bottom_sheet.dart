import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilidade_urbana_app/features/favorites/domain/entities/favorite_entity.dart';
import 'package:mobilidade_urbana_app/features/favorites/presentation/controllers/favorite_controller.dart';
import 'package:mobilidade_urbana_app/utils/constants/colors.dart';
import 'package:mobilidade_urbana_app/utils/constants/sizes.dart';

class FavoriteFormBottomSheet extends ConsumerStatefulWidget {
  final FavoriteEntity? favorite;

  const FavoriteFormBottomSheet({super.key, this.favorite});

  @override
  ConsumerState<FavoriteFormBottomSheet> createState() =>
      _FavoriteFormBottomSheetState();
}

class _FavoriteFormBottomSheetState
    extends ConsumerState<FavoriteFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _cepController;
  late final TextEditingController _addressController;

  bool _submitting = false;
  bool _cepLoading = false;
  String? _cepError;

  bool get _isEditing => widget.favorite != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.favorite?.favoriteName ?? '');
    _addressController =
        TextEditingController(text: widget.favorite?.address ?? '');
    _cepController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cepController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ── CEP lookup ─────────────────────────────────────────────────────────────

  Future<void> _onCepChanged(String value) async {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) return;

    setState(() {
      _cepLoading = true;
      _cepError = null;
    });

    try {
      final response =
          await Dio().get('https://viacep.com.br/ws/$digits/json/');
      final data = response.data as Map<String, dynamic>;

      if (data['erro'] == true) {
        setState(() => _cepError = 'CEP não encontrado');
        return;
      }

      final parts = <String>[];
      final logradouro = data['logradouro'] as String? ?? '';
      final bairro = data['bairro'] as String? ?? '';
      final cidade = data['localidade'] as String? ?? '';
      final uf = data['uf'] as String? ?? '';

      if (logradouro.isNotEmpty) parts.add(logradouro);
      if (bairro.isNotEmpty) parts.add(bairro);

      final cityState = [cidade, uf].where((s) => s.isNotEmpty).join('/');
      final address = cityState.isNotEmpty
          ? '${parts.join(', ')} - $cityState'
          : parts.join(', ');

      _addressController.text = address.trim();
    } on DioException {
      setState(() => _cepError = 'Erro ao consultar o CEP');
    } finally {
      if (mounted) setState(() => _cepLoading = false);
    }
  }

  // ── Submissão ──────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final notifier = ref.read(favoriteControllerProvider.notifier);
    final name = _nameController.text.trim();
    final address = _addressController.text.trim().isEmpty
        ? null
        : _addressController.text.trim();

    final bool success;
    if (_isEditing) {
      success = await notifier.updateFavorite(FavoriteEntity(
        favoriteId: widget.favorite!.favoriteId,
        favoriteName: name,
        address: address,
        createdAt: widget.favorite!.createdAt,
      ));
    } else {
      success = await notifier.addFavorite(FavoriteEntity(
        favoriteName: name,
        address: address,
      ));
    }

    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      Navigator.pop(context);
    } else {
      final error = ref.read(favoriteControllerProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Erro ao salvar favorito')),
      );
    }
  }

  // ── UI ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: TSizes.md,
        right: TSizes.md,
        top: TSizes.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.md,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: TSizes.sm),
            Text(
              _isEditing ? 'Editar favorito' : 'Novo favorito',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: TSizes.sm),

            // Nome
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nome',
                hintText: 'Ex: Casa, Trabalho...',
                prefixIcon: const Icon(Icons.label_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                ),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe um nome' : null,
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // CEP
            TextFormField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CepInputFormatter(),
              ],
              onChanged: _onCepChanged,
              decoration: InputDecoration(
                labelText: 'CEP (opcional)',
                hintText: '00000-000',
                prefixIcon: const Icon(Icons.pin_drop_outlined),
                suffixIcon: _cepLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                errorText: _cepError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            // Endereço (preenchido pelo CEP ou manualmente)
            TextFormField(
              controller: _addressController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Endereço (opcional)',
                hintText: 'Preenchido automaticamente pelo CEP',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                ),
              ),
            ),
            const SizedBox(height: TSizes.md),

            // Botão salvar
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
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: TColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(_isEditing ? 'Salvar alterações' : 'Adicionar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formata o CEP enquanto o usuário digita: `12345678` → `12345-678`
class _CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
