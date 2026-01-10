import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/models/baby_model.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';

class BabySettingsPage extends StatefulWidget {
  final String babyGender;
  final String babyId;

  const BabySettingsPage({
    super.key,
    required this.babyGender,
    required this.babyId,
  });

  @override
  State<BabySettingsPage> createState() => _BabySettingsPageState();
}

class _BabySettingsPageState extends State<BabySettingsPage> {
  late TextEditingController _nameController;
  String _selectedGender = 'boy';

  Color get primaryColor =>
      _selectedGender == 'girl' ? const Color(0xFFFF9EC9) : const Color(0xFF87CEEB);

  Color get lightColor =>
      _selectedGender == 'girl' ? const Color(0xFFFFC6E0) : const Color(0xFFB0E0E6);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedGender = widget.babyGender;
    _loadBabyData();
  }

  void _loadBabyData() {
    final babyCubit = context.read<BabyCubit>();
    babyCubit.loadBabyProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveBabyChanges() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter baby name')),
      );
      return;
    }

    final state = context.read<BabyCubit>().state;
    if (state is! BabyLoaded) return;

    final babyCubit = context.read<BabyCubit>();
    final updatedBaby = BabyModel(
      id: state.baby.id,
      userId: state.baby.userId,
      name: _nameController.text,
      gender: _selectedGender,
      dateOfBirth: state.baby.dateOfBirth,
      birthWeight: state.baby.birthWeight,
      birthHeight: state.baby.birthHeight,
      themeColor: state.baby.themeColor,
      isActive: state.baby.isActive,
      createdAt: state.baby.createdAt,
      updatedAt: DateTime.now(),
    );

    babyCubit.updateBabyProfile(updatedBaby);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Baby profile updated successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Baby Settings'),
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<BabyCubit, BabyState>(
        builder: (context, state) {
          if (state is BabyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BabyLoaded) {
            // Initialize name and gender on first load
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_nameController.text.isEmpty && mounted) {
                setState(() {
                  _nameController.text = state.baby.name;
                  _selectedGender = state.baby.gender ?? 'boy';
                });
              }
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baby Avatar
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: lightColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _selectedGender == 'girl' ? Icons.favorite : Icons.child_care,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Baby Name Field
                Text(
                  'Baby Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter baby name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.child_care),
                  ),
                ),
                const SizedBox(height: 30),

                // Gender Selection
                Text(
                  'Baby Gender',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = 'boy'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedGender == 'boy'
                                ? const Color(0xFF87CEEB)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedGender == 'boy'
                                  ? const Color(0xFF87CEEB)
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.child_care,
                                  color: _selectedGender == 'boy'
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Boy',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedGender == 'boy'
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedGender = 'girl'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedGender == 'girl'
                                ? const Color(0xFFFF9EC9)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedGender == 'girl'
                                  ? const Color(0xFFFF9EC9)
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: _selectedGender == 'girl'
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Girl',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _selectedGender == 'girl'
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _saveBabyChanges,
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
