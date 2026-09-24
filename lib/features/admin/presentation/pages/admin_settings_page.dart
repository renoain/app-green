// Halaman pengaturan operasional admin (baca + tulis).
//
// Nilai dari app_settings via adminSettingsProvider (fallback default);
// simpan tervalidasi di ManageSettingsUsecase lalu diterapkan ke
// AppConfig agar langsung berlaku.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../domain/entities/app_settings_values.dart';
import '../../domain/usecases/manage_settings_usecase.dart';
import '../providers/admin_providers.dart';
import '../providers/admin_settings_provider.dart';

/// Halaman pengaturan admin.
class AdminSettingsPage extends ConsumerStatefulWidget {
  /// Membuat halaman pengaturan admin.
  const AdminSettingsPage({super.key});

  @override
  ConsumerState<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends ConsumerState<AdminSettingsPage> {
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _bonusOrganikController =
      TextEditingController();
  final TextEditingController _bonusAnorganikController =
      TextEditingController();
  final TextEditingController _bonusDaurUlangController =
      TextEditingController();
  final TextEditingController _bonusB3Controller = TextEditingController();
  bool _enforce = true;
  bool _filled = false;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _rateController.dispose();
    _targetController.dispose();
    _photoController.dispose();
    _bonusOrganikController.dispose();
    _bonusAnorganikController.dispose();
    _bonusDaurUlangController.dispose();
    _bonusB3Controller.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    if (!mounted) return;
    setState(() => _filled = false);
    await ref.read(adminSettingsProvider.notifier).load();
  }

  void _fill(AppSettingsValues values) {
    _radiusController.text = '${values.gpsRadiusMeters}';
    _rateController.text = '${values.maxWasteLogsPerDay}';
    _targetController.text = '${values.weeklyMissionTarget}';
    _photoController.text = '${values.maxPhotoMb}';
    _bonusOrganikController.text = '${values.bonusOrganik}';
    _bonusAnorganikController.text = '${values.bonusAnorganik}';
    _bonusDaurUlangController.text = '${values.bonusDaurUlang}';
    _bonusB3Controller.text = '${values.bonusB3}';
    _enforce = values.enforceGpsRadius;
    _filled = true;
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      int num(TextEditingController c) =>
          int.tryParse(c.text.trim()) ?? -1;
      final AppSettingsValues values = AppSettingsValues(
        gpsRadiusMeters: num(_radiusController),
        enforceGpsRadius: _enforce,
        maxWasteLogsPerDay: num(_rateController),
        weeklyMissionTarget: num(_targetController),
        maxPhotoMb: num(_photoController),
        bonusOrganik: num(_bonusOrganikController),
        bonusAnorganik: num(_bonusAnorganikController),
        bonusDaurUlang: num(_bonusDaurUlangController),
        bonusB3: num(_bonusB3Controller),
      );
      await ref.read(adminSettingsProvider.notifier).save(values);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.adminSettingsSaved)),
      );
    } on SettingsValidationException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AppSettingsValues> state =
        ref.watch(adminSettingsProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.adminSettings,
        leading: LucideIcons.menu,
        onLeadingTap: () => ref.read(adminDrawerOpenerProvider)?.call(),
      ),
      body: SafeArea(
        child: state.when(
          loading: () => const LoadingIndicator(),
          error: (Object error, StackTrace _) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: <Widget>[
                Text('$error', style: AppTypography.bodySm),
                const SizedBox(height: AppSpacing.md),
                AppTextButton(
                  text: AppStrings.retryButton,
                  onPressed: _reload,
                ),
              ],
            ),
          ),
          data: (AppSettingsValues values) {
            if (!_filled) _fill(values);
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _reload,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: <Widget>[
                  const Text(
                    AppStrings.adminSettingsSecurityTitle,
                    style: AppTypography.headlineSm,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomTextField(
                    label: AppStrings.adminSettingsRadiusLabel,
                    controller: _radiusController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Text(
                          AppStrings.adminSettingsEnforceLabel,
                          style: AppTypography.labelLg,
                        ),
                      ),
                      Switch(
                        value: _enforce,
                        onChanged: (bool v) =>
                            setState(() => _enforce = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    AppStrings.adminSettingsMissionTitle,
                    style: AppTypography.headlineSm,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomTextField(
                    label: AppStrings.adminSettingsRateLabel,
                    controller: _rateController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomTextField(
                    label: AppStrings.adminSettingsTargetLabel,
                    controller: _targetController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomTextField(
                    label: AppStrings.adminSettingsPhotoLabel,
                    controller: _photoController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    AppStrings.adminSettingsBonusTitle,
                    style: AppTypography.headlineSm,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomTextField(
                    label: AppStrings.adminSettingsBonusOrganik,
                    controller: _bonusOrganikController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomTextField(
                    label: AppStrings.adminSettingsBonusAnorganik,
                    controller: _bonusAnorganikController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomTextField(
                    label: AppStrings.adminSettingsBonusDaurUlang,
                    controller: _bonusDaurUlangController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  CustomTextField(
                    label: AppStrings.adminSettingsBonusB3,
                    controller: _bonusB3Controller,
                    keyboardType: TextInputType.number,
                  ),
                  if (_error != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Text(_error!, style: AppTypography.bodySm),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    text: AppStrings.adminSettingsSave,
                    onPressed: _saving ? null : _save,
                    isLoading: _saving,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDim,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Text(
                      AppStrings.adminSettingsPhaseNote,
                      style: AppTypography.bodySm,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
