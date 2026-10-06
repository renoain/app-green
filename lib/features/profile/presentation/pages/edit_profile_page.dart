// Halaman edit profil sesuai docs/UI_PAGES.md (Profile).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_env.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/profile_dummy_datasource.dart';
import '../providers/profile_provider.dart';

/// Halaman pengaturan data profil (nama, telepon, email).
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _initialized = false;
  bool _isLoading = false;
  bool _isLoadingDummy = false;
  String? _dummyProfileId;

  final RegExp _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  final RegExp _phoneRegExp = RegExp(r'^\+?[0-9]{9,15}$');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    _initialized = true;
    if (AppEnv.useDummyApi) {
      _loadDummyProfile();
      return;
    }
    final AuthRepository repository = ref.read(authRepositoryProvider);
    final ({String? email, String? displayName, String? username, String? phone})
    account = repository.currentAccount;
    final String email = account.email ?? ref
        .read(authNotifierProvider)
        .userEmail ??
        AppStrings.profileDemoEmail;
    _nameController.text = account.displayName ?? AppStrings.guestName;
    _emailController.text = email;
    _phoneController.text = account.phone ?? '';
  }

  /// Muat profil dummy dari json-server (nama = username, email bisa diubah).
  Future<void> _loadDummyProfile() async {
    setState(() => _isLoadingDummy = true);
    final String profileId =
        SupabaseService.instance.currentUser?.id ??
        ProfileDummyDatasource.demoProfileId;
    _dummyProfileId = profileId;
    try {
      final ProfileDummyDatasource datasource = ref.read(
        profileDummyDatasourceProvider,
      );
      final profile = await datasource.getProfileById(profileId);
      if (!mounted) {
        return;
      }
      _nameController.text = profile?.username ?? AppStrings.guestName;
      _emailController.text = profile?.email ?? AppStrings.profileDemoEmail;
    } catch (_) {
      _nameController.text = AppStrings.guestName;
      _emailController.text = AppStrings.profileDemoEmail;
    } finally {
      if (mounted) {
        setState(() => _isLoadingDummy = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final bool saved;
    if (AppEnv.useDummyApi) {
      saved = await _saveDummyProfile();
    } else {
      final AuthRepository repository = ref.read(authRepositoryProvider);
      final String phone = _phoneController.text.trim();
      saved = await repository.updateProfile(
        displayName: _nameController.text.trim(),
        phone: phone.isEmpty ? null : phone,
      );
    }
    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    if (!saved) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(AppStrings.genericError)));
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(AppStrings.profileSaved)));
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRouteName.profile);
    }
  }

  /// Simpan nama (username) dan email ke tabel profiles di json-server.
  Future<bool> _saveDummyProfile() async {
    final String profileId =
        _dummyProfileId ??
        SupabaseService.instance.currentUser?.id ??
        ProfileDummyDatasource.demoProfileId;
    try {
      final ProfileDummyDatasource datasource = ref.read(
        profileDummyDatasourceProvider,
      );
      await datasource.updateProfile(
        id: profileId,
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDummy = AppEnv.useDummyApi;
    final bool isBusy = _isLoading || _isLoadingDummy;
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.editProfile,
        leading: LucideIcons.arrow_left,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                AppStrings.editProfileCaption,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomTextField(
                label: AppStrings.nameLabel,
                hint: AppStrings.nameHint,
                prefixIcon: LucideIcons.user,
                controller: _nameController,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.errorNameRequired;
                  }
                  if (value.trim().length < 2) {
                    return AppStrings.errorDisplayNameTooShort;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: AppStrings.emailLabel,
                hint: AppStrings.emailHint,
                prefixIcon: LucideIcons.mail,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: isDummy,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.errorEmailRequired;
                  }
                  if (!_emailRegExp.hasMatch(value.trim())) {
                    return AppStrings.errorEmailInvalid;
                  }
                  return null;
                },
              ),
              if (!isDummy) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  label: AppStrings.phoneLabel,
                  hint: AppStrings.phoneHint,
                  prefixIcon: LucideIcons.phone,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return null;
                    }
                    if (!_phoneRegExp.hasMatch(value.trim())) {
                      return AppStrings.errorPhoneInvalid;
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: AppStrings.saveButton,
                isLoading: _isLoading,
                onPressed: isBusy ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
