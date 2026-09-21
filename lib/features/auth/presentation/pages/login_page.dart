// Halaman login: form email dan kata sandi dengan validasi. Setelah
// login berhasil, berpindah ke Home.

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_enums.dart';
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

/// Halaman login Go Green.
class LoginPage extends ConsumerStatefulWidget {
  /// Membuat halaman login.
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _identityController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberMe = true;

  String? _validateIdentity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.loginIdentityRequired;
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);
    final AuthRepository repository = ref.read(authRepositoryProvider);
    final SignInResult result = await repository.signIn(
      identifier: _identityController.text.trim(),
      password: _passwordController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);
    if (result != SignInResult.success) {
      _showLoginError(result);
      return;
    }
    final UserRole role = await getCurrentUserRole();
    if (!mounted) {
      return;
    }
    context.goNamed(_homeForRole(role));
  }

  void _showLoginError(SignInResult result) {
    final String message = switch (result) {
      SignInResult.invalidCredentials => AppStrings.errorLoginInvalid,
      SignInResult.notConfirmed => AppStrings.errorEmailNotConfirmed,
      SignInResult.networkError => AppStrings.errorNetwork,
      _ => AppStrings.errorLoginFailed,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Menangani tombol "Masuk dengan Google": satu klik langsung login
  /// tanpa mengisi email manual.
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
    final UserRole role = await getCurrentUserRole();
    if (!mounted) {
      return;
    }
    context.goNamed(_homeForRole(role));
  }

  /// Menampilkan pesan error khusus login Google.
  void _showGoogleLoginError(SignInResult result) {
    final String message = switch (result) {
      SignInResult.networkError => AppStrings.errorNetwork,
      _ => AppStrings.errorGoogleLoginFailed,
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToRegister() {
    context.goNamed(AppRouteName.register);
  }

  /// Route tujuan pasca-login berdasarkan role.
  String _homeForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return AppRouteName.adminDashboard;
      case UserRole.petugas:
        return AppRouteName.adminWasteVerification;
      case UserRole.user:
        return AppRouteName.home;
    }
  }

  /// Menampilkan pemberitahuan sementara untuk menu yang belum tersedia.
  void _showForgotPasswordNotice() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text(AppStrings.menuNotAvailable)),
      );
  }

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
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
                      AppStrings.loginTitle,
                      style: AppTypography.headlineXl,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const Text(
                      AppStrings.loginSubtitle,
                      style: AppTypography.bodyMd,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    CustomTextField(
                      label: AppStrings.loginIdentityLabel,
                      hint: AppStrings.loginIdentityHint,
                      prefixIcon: LucideIcons.user,
                      controller: _identityController,
                      validator: _validateIdentity,
                      keyboardType: TextInputType.text,
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
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Transform.scale(
                              scale: 0.8,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: AppColors.primary,
                                onChanged: (bool? value) {
                                  setState(
                                    () => _rememberMe = value ?? false,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            const Text(
                              AppStrings.rememberMe,
                              style: AppTypography.bodySm,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed:
                              _isLoading ? null : _showForgotPasswordNotice,
                          child: const Text(AppStrings.forgotPassword),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      text: AppStrings.loginButton,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _handleLogin,
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
                      text: AppStrings.loginWithGoogle,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: AppTextButton(
                        text: AppStrings.registerPrompt,
                        onPressed: _isLoading ? null : _goToRegister,
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

