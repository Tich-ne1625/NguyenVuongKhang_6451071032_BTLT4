import 'package:flutter/material.dart';
import '../models/multi_step_model.dart';
import '../utils/validators.dart';
import '../widgets/step_indicator.dart';

class MultiStepView extends StatefulWidget {
  const MultiStepView({super.key});

  @override
  State<MultiStepView> createState() => _MultiStepViewState();
}

class _MultiStepViewState extends State<MultiStepView> {
  int _currentStep = 0;
  final MultiStepModel _data = MultiStepModel();

  // Step 1 form
  final _step1FormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Step 2
  final Map<String, bool> _interests = {
    'Công nghệ': false,
    'Âm nhạc': false,
    'Thể thao': false,
    'Du lịch': false,
    'Ẩm thực': false,
    'Đọc sách': false,
  };
  double _budget = 5.0;
  String? _interestsError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  List<String> get _selectedInterests =>
      _interests.entries.where((e) => e.value).map((e) => e.key).toList();

  bool _validateStep1() {
    return _step1FormKey.currentState?.validate() == true;
  }

  bool _validateStep2() {
    final error = Validators.validateInterests(_selectedInterests);
    setState(() => _interestsError = error);
    return error == null;
  }

  void _goNext() {
    if (_currentStep == 0) {
      if (_validateStep1()) {
        _data.fullName = _nameController.text.trim();
        _data.email = _emailController.text.trim();
        _data.phone = _phoneController.text.trim();
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 1) {
      if (_validateStep2()) {
        _data.interests = _selectedInterests;
        _data.budget = _budget;
        setState(() => _currentStep++);
      }
    }
  }

  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _onSubmit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.teal),
            SizedBox(width: 8),
            Text('Đăng Ký Thành Công!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Thông tin đã đăng ký:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              Text('Họ tên: ${_data.fullName}'),
              Text('Email: ${_data.email}'),
              Text('SĐT: ${_data.phone}'),
              const SizedBox(height: 8),
              const Text('Sở thích:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ..._data.interests.map((i) => Text('• $i')),
              const SizedBox(height: 4),
              Text('Ngân sách: ${_data.budget.toStringAsFixed(1)} triệu/tháng'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentStep = 0;
                _nameController.clear();
                _emailController.clear();
                _phoneController.clear();
                _interests.updateAll((key, value) => false);
                _budget = 5.0;
              });
            },
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông Tin Cá Nhân',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameController,
            validator: Validators.validateFullName,
            decoration: InputDecoration(
              labelText: 'Họ và tên',
              prefixIcon: const Icon(Icons.person),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            validator: Validators.validateEmail,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            validator: Validators.validatePhone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Số điện thoại',
              prefixIcon: const Icon(Icons.phone),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sở Thích & Ngân Sách',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Chọn sở thích:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        ..._interests.keys.map(
          (interest) => CheckboxListTile(
            title: Text(interest),
            value: _interests[interest]!,
            activeColor: Colors.teal,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              setState(() {
                _interests[interest] = value ?? false;
                _interestsError =
                    Validators.validateInterests(_selectedInterests);
              });
            },
          ),
        ),
        if (_interestsError != null)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(_interestsError!,
                style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
        const Divider(height: 24),
        const Text(
          'Ngân sách dự kiến (triệu/tháng):',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Slider(
          value: _budget,
          min: 0,
          max: 50,
          divisions: 50,
          activeColor: Colors.teal,
          label: '${_budget.toStringAsFixed(1)} triệu',
          onChanged: (value) => setState(() => _budget = value),
        ),
        Center(
          child: Text(
            '${_budget.toStringAsFixed(1)} triệu/tháng',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Xác Nhận Thông Tin',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Thông tin cá nhân:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                _infoRow(Icons.person, 'Họ tên', _data.fullName),
                _infoRow(Icons.email, 'Email', _data.email),
                _infoRow(Icons.phone, 'SĐT', _data.phone),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sở thích & Ngân sách:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                const Text('Sở thích:', style: TextStyle(fontWeight: FontWeight.w500)),
                ..._data.interests.map(
                  (i) => Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.teal, size: 16),
                        const SizedBox(width: 8),
                        Text(i),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _infoRow(Icons.attach_money, 'Ngân sách',
                    '${_data.budget.toStringAsFixed(1)} triệu/tháng'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.teal),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.teal),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Vui lòng kiểm tra lại thông tin trước khi xác nhận.',
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.teal),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stepLabels = ['Cá nhân', 'Sở thích', 'Xác nhận'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài 8: Form Nhiều Bước'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.teal[50],
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MSSV: 6451071032',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                StepIndicator(
                  currentStep: _currentStep,
                  totalSteps: 3,
                  stepLabels: stepLabels,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
              ][_currentStep],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _goBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.teal),
                      ),
                      child: const Text('Quay lại',
                          style: TextStyle(color: Colors.teal)),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _currentStep < 2 ? _goNext : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      _currentStep < 2 ? 'Tiếp theo' : 'Xác nhận & Gửi',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
