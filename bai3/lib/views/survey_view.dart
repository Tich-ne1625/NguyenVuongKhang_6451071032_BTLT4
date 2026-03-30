import 'package:flutter/material.dart';
import '../models/survey_model.dart';
import '../utils/validators.dart';
import '../widgets/custom_checkbox_tile.dart';

class SurveyView extends StatefulWidget {
  const SurveyView({super.key});

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  final _noteController = TextEditingController();
  String? _hobbiesError;
  String? _satisfactionError;

  final Map<String, bool> _hobbies = {
    'Đọc sách': false,
    'Thể thao': false,
    'Âm nhạc': false,
    'Du lịch': false,
    'Nấu ăn': false,
    'Chơi game': false,
    'Vẽ / Nghệ thuật': false,
    'Lập trình': false,
  };

  final List<String> _satisfactionLevels = [
    'Rất không hài lòng',
    'Không hài lòng',
    'Bình thường',
    'Hài lòng',
    'Rất hài lòng',
  ];
  String? _selectedSatisfaction;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  List<String> get _selectedHobbies =>
      _hobbies.entries.where((e) => e.value).map((e) => e.key).toList();

  void _onSubmit() {
    final hobbiesErr = Validators.validateHobbies(_selectedHobbies);
    final satisfactionErr = Validators.validateSatisfaction(_selectedSatisfaction);

    setState(() {
      _hobbiesError = hobbiesErr;
      _satisfactionError = satisfactionErr;
    });

    if (hobbiesErr == null && satisfactionErr == null) {
      final survey = SurveyModel(
        hobbies: _selectedHobbies,
        satisfactionLevel: _selectedSatisfaction!,
        note: _noteController.text,
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kết Quả Khảo Sát'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sở thích:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...survey.hobbies.map((h) => Text('• $h')),
                const SizedBox(height: 8),
                Text('Mức độ hài lòng: ${survey.satisfactionLevel}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (survey.note.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Ghi chú: ${survey.note}'),
                ],
              ],
            ),
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
        title: const Text('Bài 3: Form Khảo Sát'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: const Text(
                'MSSV: 6451071032',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Khảo Sát Sở Thích',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Sở thích
            const Text(
              'Chọn sở thích của bạn (bắt buộc chọn ít nhất 1):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            ..._hobbies.keys.map(
              (hobby) => CustomCheckboxTile(
                title: hobby,
                value: _hobbies[hobby]!,
                onChanged: (value) {
                  setState(() {
                    _hobbies[hobby] = value ?? false;
                    _hobbiesError = Validators.validateHobbies(_selectedHobbies);
                  });
                },
              ),
            ),
            if (_hobbiesError != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  _hobbiesError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const Divider(height: 24),
            // Mức độ hài lòng
            const Text(
              'Mức độ hài lòng về dịch vụ:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            RadioGroup<String>(
              groupValue: _selectedSatisfaction,
              onChanged: (value) {
                setState(() {
                  _selectedSatisfaction = value;
                  _satisfactionError =
                      Validators.validateSatisfaction(value);
                });
              },
              child: Column(
                children: _satisfactionLevels
                    .map((level) => RadioListTile<String>(
                          title: Text(level),
                          value: level,
                        ))
                    .toList(),
              ),
            ),
            if (_satisfactionError != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  _satisfactionError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const Divider(height: 24),
            // Ghi chú
            const Text(
              'Ghi chú (tùy chọn):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Nhập ghi chú hoặc ý kiến thêm...',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Gửi Khảo Sát',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
