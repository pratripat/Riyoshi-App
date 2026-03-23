import 'package:flutter/material.dart';

class NewBookingSheet extends StatefulWidget {
  const NewBookingSheet({super.key});

  @override
  State<NewBookingSheet> createState() => _NewBookingSheetState();
}

class _NewBookingSheetState extends State<NewBookingSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedSpecialist;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;

  final List<String> _specialists = ['Amir', 'Riya', 'Rahul', 'Unassigned'];

  final List<Map<String, dynamic>> _allServices = [
    {'name': 'Haircut', 'duration': 30},
    {'name': 'Beard Trim', 'duration': 15},
    {'name': 'Male Hair Colour', 'duration': 60},
    {'name': 'Hair Spa', 'duration': 60},
    {'name': 'Facial', 'duration': 45},
    {'name': 'Shave', 'duration': 20},
  ];

  final List<int> _selectedServiceIndexes = [];

  List<String> get _timeSlots {
    final slots = <String>[];
    for (int h = 9; h <= 20; h++) {
      for (int m = 0; m < 60; m += 15) {
        final hour = h.toString().padLeft(2, '0');
        final min = m.toString().padLeft(2, '0');
        slots.add('$hour:$min');
      }
    }
    return slots;
  }

  int get _totalDuration => _selectedServiceIndexes.fold(
      0, (sum, i) => sum + (_allServices[i]['duration'] as int));

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6C63FF),
            surface: Color(0xFF1E1E2A),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF13131A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Title ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New Appointment',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Customer + Phone ──
            Row(
              children: [
                Expanded(
                  child: _buildField(
                    label: 'CUSTOMER',
                    child: _inputBox(
                      controller: _nameController,
                      hint: 'Name',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildField(
                    label: 'PHONE',
                    child: _inputBox(
                      controller: _phoneController,
                      hint: '+91...',
                      keyboard: TextInputType.phone,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Select Services ──
            _sectionLabel('SELECT SERVICES'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_allServices.length, (i) {
                      final selected = _selectedServiceIndexes.contains(i);
                      return GestureDetector(
                        onTap: () => setState(() {
                          selected
                              ? _selectedServiceIndexes.remove(i)
                              : _selectedServiceIndexes.add(i);
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF6C63FF)
                                : const Color(0xFF2A2A3A),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF6C63FF)
                                  : Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Text(
                            _allServices[i]['name'],
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.grey[400],
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: ${_selectedServiceIndexes.length} service${_selectedServiceIndexes.length == 1 ? '' : 's'} (${_totalDuration}m)',
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Specialist ──
            _sectionLabel('SPECIALIST'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSpecialist,
                  hint: Text('Select Specialist',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E1E2A),
                  iconEnabledColor: Colors.grey,
                  items: _specialists
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedSpecialist = v),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Date ──
            _sectionLabel('DATE'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(_selectedDate),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const Icon(Icons.calendar_today_outlined,
                        color: Colors.grey, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Time Slots ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionLabel('AVAILABLE TIME SLOTS'),
                if (_selectedSpecialist == null)
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text('Select Specialist',
                          style: TextStyle(
                              color: Colors.orange[400], fontSize: 11)),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.2,
              ),
              itemCount: _timeSlots.length,
              itemBuilder: (_, i) {
                final slot = _timeSlots[i];
                final isSelected = _selectedTime == slot;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = slot),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6C63FF)
                          : const Color(0xFF1E1E2A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF6C63FF)
                            : Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: Text(
                      slot,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[300],
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ── Buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[700]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _selectedServiceIndexes.isEmpty ? null : () {
                      // hook up to API later
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      disabledBackgroundColor: const Color(0xFF3A3A5A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Confirm ${_selectedServiceIndexes.length} Service${_selectedServiceIndexes.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: TextStyle(
            color: Colors.grey[500],
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1),
      );

  Widget _buildField({required String label, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(label),
          const SizedBox(height: 6),
          child,
        ],
      );

  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) =>
      TextField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        cursorColor: const Color(0xFF6C63FF),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          filled: true,
          fillColor: const Color(0xFF1E1E2A),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      );
}