import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import 'auth_view_model.dart';
import '../settings/server_config_dialog.dart';
import '../navigation/main_navigation_scaffold.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController(text: 'kythuat.hn');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() async {
    final authVM = context.read<AuthViewModel>();
    final success = await authVM.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScaffold()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryNavy.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_outlined,
                        size: 56,
                        color: AppTheme.primaryNavy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryNavy,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.appFullName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Error Message
                  if (authVM.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              authVM.errorMessage!,
                              style: TextStyle(color: Colors.red.shade800, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Username Input
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên đăng nhập / Mã kỹ sư',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: authVM.isLoading ? null : _submitLogin,
                    child: authVM.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text('ĐĂNG NHẬP'),
                  ),
                  const SizedBox(height: 16),

                  // Quick Demo Role Chips
                  const Center(
                    child: Text('Tài khoản mẫu thử nghiệm:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionChip(
                        label: const Text('Kỹ thuật viên', style: TextStyle(fontSize: 11)),
                        avatar: const Icon(Icons.engineering, size: 14),
                        onPressed: () {
                          _usernameController.text = 'kythuat.hn';
                          _passwordController.text = '123456';
                        },
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        label: const Text('Trưởng nhóm (Leader)', style: TextStyle(fontSize: 11)),
                        avatar: const Icon(Icons.supervisor_account, size: 14),
                        onPressed: () {
                          _usernameController.text = 'leader.hanoi';
                          _passwordController.text = '123456';
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Server Config button
                  TextButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const ServerConfigDialog(),
                    ),
                    icon: const Icon(Icons.settings_ethernet, size: 16),
                    label: const Text('Cấu hình Máy chủ & Port', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
