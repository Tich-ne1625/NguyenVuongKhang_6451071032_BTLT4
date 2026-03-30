import 'package:flutter/material.dart';
import '../models/account_model.dart';
import '../utils/validators.dart';
import '../widgets/password_field.dart';

class AdvancedRegisterView extends StatefulWidget {
  const AdvancedRegisterView({super.key});

  @override
  State<AdvancedRegisterView> createState() => _AdvancedRegisterViewState();
}

class _AdvancedRegisterViewState extends State<AdvancedRegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  PasswordStrength _passwordStrength = PasswordStrength.empty;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Color _strengthColor() {
    switch (_passwordStrength) {
      case PasswordStrength.empty:
        return Colors.grey;
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  String _strengthLabel() {
    switch (_passwordStrength) {
      case PasswordStrength.empty:
        return '';
      case PasswordStrength.weak:
        return 'Yếu';
      case PasswordStrength.medium:
        return 'Trung bình';
      case PasswordStrength.strong:
        return 'Mạnh';
    }
  }

  double _strengthValue() {
    switch (_passwordStrength) {
      case PasswordStrength.empty:
        return 0;
      case PasswordStrength.weak:
        return 0.33;
      case PasswordStrength.medium:
        return 0.66;
      case PasswordStrength.strong:
        return 1.0;
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final account = AccountModel(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Đăng Ký Thành Công!'),
            ],
          ),
          content: Text(
              'Tài khoản "${account.username}" đã được tạo thành công.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _formKey.currentState!.reset();
                _usernameController.clear();
                _passwordController.clear();
                _confirmPasswordController.clear();
                setState(() => _passwordStrength = PasswordStrength.empty);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 6: Đăng Ký Nâng Cao'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple),
                ),
                child: const Text(
                  'MSSV: 6451071032',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tạo Tài Khoản',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Validate realtime khi nhập',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              // Username
              TextFormField(
                controller: _usernameController,
                focusNode: _usernameFocus,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: Validators.validateUsername,
                onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  hintText: 'Ít nhất 4 ký tự, chỉ chữ, số và _',
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),
              // Password
              PasswordField(
                label: 'Mật khẩu',
                hint: 'Ít nhất 8 ký tự, có chữ hoa và số',
                controller: _passwordController,
                focusNode: _passwordFocus,
                textInputAction: TextInputAction.next,
                validator: Validators.validatePassword,
                onChanged: (value) {
                  setState(() {
                    _passwordStrength =
                        Validators.getPasswordStrength(value);
                  });
                  // Re-validate confirm field
                  _formKey.currentState?.validate();
                },
              ),
              // Password strength indicator
              if (_passwordController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: _strengthValue(),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(_strengthColor()),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _strengthLabel(),
                      style: TextStyle(
                        color: _strengthColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Yêu cầu mật khẩu:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('• Ít nhất 8 ký tự', style: TextStyle(fontSize: 11)),
                    Text('• Ít nhất 1 chữ hoa (A-Z)', style: TextStyle(fontSize: 11)),
                    Text('• Ít nhất 1 chữ số (0-9)', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Password
              PasswordField(
                label: 'Xác nhận mật khẩu',
                hint: 'Nhập lại mật khẩu',
                controller: _confirmPasswordController,
                focusNode: _confirmFocus,
                textInputAction: TextInputAction.done,
                validator: (value) => Validators.validateConfirmPassword(
                    value, _passwordController.text),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Tạo Tài Khoản',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
