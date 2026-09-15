// Halaman edit profil sesuai docs/UI_PAGES.md (Profile).

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bar_and_loading_widgets.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';

/// Halaman pengaturan data profil (nama dan email).
///
/// Data demo diisi dari nilai sementara; penyimpanan tersedia setelah
/// autentikasi Supabase terhubung.
class EditProfilePage extends StatefulWidget {
  /// Membuat halaman edit profil.
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController(text: AppStrings.guestName);
  final TextEditingController _emailController =
      TextEditingController(text: AppStrings.profileDemoEmail);

  final RegExp _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text(AppStrings.profileSaved)));
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRouteName.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
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
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                text: AppStrings.saveButton,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}