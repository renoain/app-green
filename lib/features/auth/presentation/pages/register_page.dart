// Halaman register: form nama, email, kata sandi, dan konfirmasi kata
// sandi dengan validasi. Setelah berhasil, kembali ke halaman Login.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button_widgets.dart';
import '../../../../core/widgets/auth_leaf_decoration.dart';
import '../../../../core/widgets/custom_text_field_widget.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_provider.dart';

/// Halaman registrasi Go Green.
class RegisterPage extends ConsumerStatefulWidget {
  /// Membuat halaman registrasi.
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  static final RegExp _emailRegex = RegExp(
    r'^[\w\.-]+@[\w\.-]+\.\w+$',
  );

  static final RegExp _usernameRegex = RegExp(
    r'^[a-z0-9_]{3,20}$',
  );

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorUsernameInvalid;
    }
    if (!_usernameRegex.hasMatch(value.trim())) {
      return AppStrings.errorUsernameInvalid;
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorNameRequired;
    }
    if (value.trim().length < 2) {
      return AppStrings.errorDisplayNameTooShort;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.errorEmailRequired;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return AppStrings.errorEmailInvalid;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.errorPasswordRequired;
    }
    if (value.length < 6) {
      return AppStrings.errorPasswordTooShort;
    }
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.errorPasswordRequired;
    }
    if (value != _passwordController.text) {
      return AppStrings.errorPasswordMismatch;
    }
    return null;
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);
    final AuthRepository repository = ref.read(authRepositoryProvider);
    final SignUpResult result = await repository.signUp(
      username: _usernameController.text.trim().toLowerCase(),
      displayName: _nameController.text,
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    switch (result) {
      case SignUpResult.success:
        context.goNamed(AppRouteName.login);
      case SignUpResult.needsConfirmation:
        _showSnackBar(AppStrings.signUpConfirmationSent);
      case SignUpResult.alreadyRegistered:
        _showSnackBar(AppStrings.errorEmailRegistered);
      case SignUpResult.usernameTaken:
        _showSnackBar(AppStrings.errorUsernameTaken);
      case SignUpResult.weakPassword:
        _showSnackBar(AppStrings.errorWeakPassword);
      case SignUpResult.rateLimited:
        _showSnackBar(AppStrings.errorRateLimitExceeded);
      case SignUpResult.networkError:
        _showSnackBar(AppStrings.errorNetwork);
      case SignUpResult.error:
        _showSnackBar(AppStrings.genericError);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToLogin() {
    context.goNamed(AppRouteName.login);
  }

  /// Menangani "Daftar dengan Google": satu klik langsung membuat akun dan
  /// masuk otomatis tanpa perlu mengisi form manual.
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final AuthRepository repository = ref.read(authRepositoryProvider);
    final SignInResult result = await repository.signInWithGoogle();
    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    if (result != SignInResult.success) {
      _showGoogleLoginError(result);
      return;
    }
    context.goNamed(AppRouteName.home);
  }

  /// Menampilkan error khusus login Google saat gagal.
  void _showGoogleLoginError(SignInResult result) {
    final String message = switch (result) {
      SignInResult.networkError => AppStrings.errorNetwork,
      _ => AppStrings.errorGoogleLoginFailed,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AuthLeafDecoration()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: AppSpacing.xl),
                    const Icon(
                      LucideIcons.leaf,
                      size: 40,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      AppStrings.registerTitle,
                      style: AppTypography.headlineXl,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      AppStrings.registerSubtitle,
                      style: AppTypography.bodyMd,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    CustomTextField(
                      label: AppStrings.usernameLabel,
                      hint: AppStrings.usernameHint,
                      prefixIcon: LucideIcons.at_sign,
                      controller: _usernameController,
                      validator: _validateUsername,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      label: AppStrings.nameLabel,
                      hint: AppStrings.nameHint,
                      prefixIcon: LucideIcons.user,
                      controller: _nameController,
                      validator: _validateName,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      label: AppStrings.emailLabel,
                      hint: AppStrings.emailHint,
                      prefixIcon: LucideIcons.mail,
                      controller: _emailController,
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      label: AppStrings.passwordLabel,
                      hint: AppStrings.passwordHint,
                      prefixIcon: LucideIcons.lock,
                      suffixIcon:
                          _obscurePassword ? LucideIcons.eye : LucideIcons.eye_off,
                      onSuffixTap: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      controller: _passwordController,
                      validator: _validatePassword,
                      obscureText: _obscurePassword,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      label: AppStrings.confirmPasswordLabel,
                      hint: AppStrings.confirmPasswordHint,
                      prefixIcon: LucideIcons.lock,
                      suffixIcon:
                          _obscureConfirm ? LucideIcons.eye : LucideIcons.eye_off,
                      onSuffixTap: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                      controller: _confirmController,
                      validator: _validateConfirm,
                      obscureText: _obscureConfirm,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      text: AppStrings.registerButton,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _handleRegister,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Row(
                      children: <Widget>[
                        Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: Text(
                            AppStrings.orDivider,
                            style: AppTypography.labelMd,
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GoogleAuthButton(
                      text: AppStrings.registerWithGoogle,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: AppTextButton(
                        text: AppStrings.loginPrompt,
                        onPressed: _isLoading ? null : _goToLogin,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Opacity(
                        opacity: 0.75,
                        child: AuthLeafSprig(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}