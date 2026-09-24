// Halaman form tambah/ubah reward admin (presentation).
//
// Validasi bisnis di ManageRewardUsecase; widget hanya menampilkan
// pesan ramah Bahasa Indonesia.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../../rewards/domain/entities/reward.dart';
import '../../../rewards/domain/usecases/manage_reward_usecase.dart';
import '../providers/admin_reward_provider.dart';

/// Form tambah/ubah reward admin.
class AdminRewardFormPage extends ConsumerStatefulWidget {
  /// Membuat form reward. [reward] null berarti mode tambah.
  const AdminRewardFormPage({super.key, this.reward});

  /// Reward yang diubah (null untuk tambah baru).
  final Reward? reward;

  @override
  ConsumerState<AdminRewardFormPage> createState() =>
      _AdminRewardFormPageState();
}

class _AdminRewardFormPageState extends ConsumerState<AdminRewardFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _costController;
  late final TextEditingController _stockController;
  late bool _isActive;
  bool _saving = false;
  String? _error;

  bool get _isEdit => widget.reward != null;

  @override
  void initState() {
    super.initState();
    final Reward? reward = widget.reward;
    _nameController = TextEditingController(text: reward?.name ?? '');
    _descController = TextEditingController(text: reward?.description ?? '');
    _costController = TextEditingController(
      text: reward == null ? '' : reward.pointsCost.toString(),
    );
    _stockController = TextEditingController(
      text: reward == null ? '' : reward.stock.toString(),
    );
    _isActive = reward?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _costController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final int cost = int.tryParse(_costController.text.trim()) ?? -1;
      final int stock = int.tryParse(_stockController.text.trim()) ?? -1;
      final notifier = ref.read(adminRewardListProvider.notifier);
      if (_isEdit) {
        await notifier.update(
          id: widget.reward!.id,
          name: _nameController.text,
          description: _descController.text,
          pointsCost: cost,
          stock: stock,
          isActive: _isActive,
        );
      } else {
        await notifier.create(
          name: _nameController.text,
          description: _descController.text,
          pointsCost: cost,
          stock: stock,
          isActive: _isActive,
        );
      }
      if (!mounted) return;
      context.pop();
    } on RewardValidationException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _isEdit
            ? AppStrings.adminRewardEditTitle
            : AppStrings.adminRewardAddTitle,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            CustomTextField(
              label: AppStrings.adminRewardNameLabel,
              controller: _nameController,
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              label: AppStrings.adminRewardDescLabel,
              controller: _descController,
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              label: AppStrings.adminRewardCostLabel,
              controller: _costController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              label: AppStrings.adminRewardStockFieldLabel,
              controller: _stockController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppStrings.adminRewardActiveSwitch,
                    style: AppTypography.labelLg,
                  ),
                ),
                Switch(value: _isActive, onChanged: (bool v) => setState(() => _isActive = v)),
              ],
            ),
            if (_error != null) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Text(_error!, style: AppTypography.bodySm),
            ],
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              text: AppStrings.adminRewardSave,
              onPressed: _saving ? null : _save,
              isLoading: _saving,
            ),
          ],
        ),
      ),
    );
  }
}
