import 'package:flutter/material.dart';
import '../models/personal_info_model.dart';
import '../utils/validators.dart';
import '../widgets/custom_dropdown.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  String? _selectedGender;
  String _maritalStatus = 'Độc thân';
  double _incomeLevel = 5.0;

  final List<String> _genderOptions = ['Nam', 'Nữ', 'Khác'];
  final List<String> _maritalOptions = ['Độc thân', 'Đã kết hôn', 'Ly hôn'];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final info = PersonalInfoModel(
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        gender: _selectedGender ?? 'Không xác định',
        maritalStatus: _maritalStatus,
        incomeLevel: _incomeLevel,
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thông Tin Cá Nhân'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tên: ${info.name}'),
              Text('Tuổi: ${info.age}'),
              Text('Giới tính: ${info.gender}'),
              Text('Tình trạng HN: ${info.maritalStatus}'),
              Text('Mức thu nhập: ${info.incomeLevel.toStringAsFixed(1)} triệu/tháng'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
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
        title: const Text('Bài 2: Thông Tin Cá Nhân'),
        backgroundColor: Colors.green,
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
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: const Text(
                  'MSSV: 6451071032',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thông Tin Cá Nhân',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Tên
              TextFormField(
                controller: _nameController,
                validator: Validators.validateName,
                decoration: InputDecoration(
                  labelText: 'Họ và tên',
                  hintText: 'Nhập họ và tên',
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),
              // Tuổi
              TextFormField(
                controller: _ageController,
                validator: Validators.validateAge,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Tuổi',
                  hintText: 'Nhập tuổi',
                  prefixIcon: const Icon(Icons.cake),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 16),
              // Giới tính
              CustomDropdown(
                label: 'Giới tính',
                value: _selectedGender,
                items: _genderOptions,
                validator: (value) =>
                    value == null ? 'Vui lòng chọn giới tính' : null,
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const SizedBox(height: 16),
              // Tình trạng hôn nhân
              const Text(
                'Tình trạng hôn nhân:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              RadioGroup<String>(
                groupValue: _maritalStatus,
                onChanged: (value) =>
                    setState(() => _maritalStatus = value!),
                child: Column(
                  children: _maritalOptions
                      .map((option) => RadioListTile<String>(
                            title: Text(option),
                            value: option,
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 8),
              // Mức thu nhập
              const Text(
                'Mức thu nhập (triệu/tháng):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('0'),
                  Expanded(
                    child: Slider(
                      value: _incomeLevel,
                      min: 0,
                      max: 50,
                      divisions: 50,
                      activeColor: Colors.green,
                      label: '${_incomeLevel.toStringAsFixed(1)} triệu',
                      onChanged: (value) =>
                          setState(() => _incomeLevel = value),
                    ),
                  ),
                  const Text('50'),
                ],
              ),
              Center(
                child: Text(
                  'Thu nhập: ${_incomeLevel.toStringAsFixed(1)} triệu/tháng',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Lưu Thông Tin',
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
