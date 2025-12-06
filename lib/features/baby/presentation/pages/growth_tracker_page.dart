// lib/features/baby/presentation/pages/growth_tracker_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/models/baby_growth_model.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/cubit/baby_state.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class GrowthTrackerPage extends StatefulWidget {
  final String? babyId;
  final String? babyGender;
  
  const GrowthTrackerPage({
    super.key,
    this.babyId,
    this.babyGender,
  });

  @override
  State<GrowthTrackerPage> createState() => _GrowthTrackerPageState();
}

class _GrowthTrackerPageState extends State<GrowthTrackerPage> {
  bool showWeight = true;
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<BabyCubit>();
    if (cubit.currentBabyId != null) {
      cubit.loadGrowthRecords();
      _hasLoadedData = true;
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Color get primaryColor =>
      widget.babyGender == 'girl' ? const Color(0xFFFF9EC9) : const Color(0xFF87CEEB);

  Color get lightColor =>
      widget.babyGender == 'girl' ? const Color(0xFFFFC6E0) : const Color(0xFFB0E0E6);

  List<FlSpot> _getChartSpots(
    List<BabyGrowthModel> records, 
    bool isWeight, {
    double? birthWeight,
    double? birthHeight,
    DateTime? birthDate,
  }) {
    final sortedRecords = records
        .where((r) => isWeight ? r.weight != null : r.height != null)
        .toList()
      ..sort((a, b) => a.recordedDate.compareTo(b.recordedDate));

    final List<FlSpot> spots = [];
    
    // Add birth data as the first point (index 0) if available
    final birthValue = isWeight ? birthWeight : birthHeight;
    if (birthValue != null && birthDate != null) {
      spots.add(FlSpot(0, birthValue));
    }
    
    // Add growth records with offset if birth data exists
    final offset = spots.isNotEmpty ? 1 : 0;
    for (int i = 0; i < sortedRecords.length; i++) {
      final value = isWeight 
          ? sortedRecords[i].weight 
          : sortedRecords[i].height;
      if (value != null) {
        spots.add(FlSpot((i + offset).toDouble(), value));
      }
    }
    
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8FF),
      body: SafeArea(
        child: BlocConsumer<BabyCubit, BabyState>(
          listener: (context, state) {
            if (state is BabyLoaded && !_hasLoadedData) {
              _hasLoadedData = true;
              context.read<BabyCubit>().loadGrowthRecords();
            }
          },
          builder: (context, state) {
            if (state is BabyLoading || state is GrowthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is BabyError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<BabyCubit>().loadBabyProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is NoBabyProfile) {
              return const Center(
                child: Text('No baby profile found. Please add your baby first.'),
              );
            }
            
            // Handle both BabyLoaded and GrowthLoaded states
            List<BabyGrowthModel> growthRecords = [];
            double? birthWeight;
            double? birthHeight;
            DateTime? birthDate;
            
            if (state is BabyLoaded) {
              growthRecords = state.growthRecords;
              birthWeight = state.baby.birthWeight;
              birthHeight = state.baby.birthHeight;
              birthDate = state.baby.dateOfBirth;
            } else if (state is GrowthLoaded) {
              growthRecords = state.growthRecords;
              birthWeight = state.baby.birthWeight;
              birthHeight = state.baby.birthHeight;
              birthDate = state.baby.dateOfBirth;
            }

            final weightRecords = growthRecords
                .where((r) => r.weight != null)
                .toList()
              ..sort((a, b) => b.recordedDate.compareTo(a.recordedDate));
            
            final heightRecords = growthRecords
                .where((r) => r.height != null)
                .toList()
              ..sort((a, b) => b.recordedDate.compareTo(a.recordedDate));
            
            final filteredRecords = showWeight ? weightRecords : heightRecords;
            final chartSpots = _getChartSpots(growthRecords, showWeight, birthWeight: birthWeight, birthHeight: birthHeight, birthDate: birthDate);
            
            // Latest values: from records or birth values if no records
            final latestWeight = weightRecords.isNotEmpty ? weightRecords.first.weight : birthWeight;
            final latestHeight = heightRecords.isNotEmpty ? heightRecords.first.height : birthHeight;
            final latestDate = (showWeight ? weightRecords : heightRecords).isNotEmpty 
                ? (showWeight ? weightRecords.first : heightRecords.first).recordedDate 
                : birthDate;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: primaryColor, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Growth Tracker',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Segmented Toggle for Weight/Height
                          Container(
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: primaryColor.withValues(alpha: 0.3), width: 1),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => showWeight = true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      decoration: BoxDecoration(
                                        color: showWeight ? primaryColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.scale,
                                              color: showWeight ? Colors.white : primaryColor,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Weight',
                                              style: TextStyle(
                                                color: showWeight ? Colors.white : primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => showWeight = false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      decoration: BoxDecoration(
                                        color: !showWeight ? primaryColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.straighten,
                                              color: !showWeight ? Colors.white : primaryColor,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Height',
                                              style: TextStyle(
                                                color: !showWeight ? Colors.white : primaryColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
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
                          ),
                          const SizedBox(height: 32),

                          // Current Weight and Height Cards - Centered
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 140,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [primaryColor, lightColor],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withValues(alpha: 0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.scale,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Weight',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.8),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          latestWeight != null
                                              ? '${latestWeight.toStringAsFixed(1)}\nkg'
                                              : '-- kg',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  width: 140,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [primaryColor, lightColor],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withValues(alpha: 0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.straighten,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Height',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.8),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          latestHeight != null
                                              ? '${latestHeight.toStringAsFixed(1)}\ncm'
                                              : '-- cm',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Chart Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      showWeight ? 'Weight Progress' : 'Height Progress',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                    if (latestDate != null)
                                      Text(
                                        'Last: ${DateFormat('MMM d').format(latestDate)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 200,
                                  child: chartSpots.length >= 2
                                      ? LineChart(
                                          LineChartData(
                                            gridData: FlGridData(
                                              show: true,
                                              drawVerticalLine: false,
                                              horizontalInterval: 1,
                                              getDrawingHorizontalLine: (value) => FlLine(
                                                color: Colors.grey[200]!,
                                                strokeWidth: 1,
                                              ),
                                            ),
                                            titlesData: FlTitlesData(
                                              leftTitles: AxisTitles(
                                                sideTitles: SideTitles(
                                                  showTitles: true,
                                                  reservedSize: 40,
                                                  getTitlesWidget: (value, meta) => Text(
                                                    '${value.toInt()} ${showWeight ? 'kg' : 'cm'}',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 10,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              bottomTitles: const AxisTitles(
                                                sideTitles: SideTitles(showTitles: false),
                                              ),
                                              topTitles: const AxisTitles(
                                                sideTitles: SideTitles(showTitles: false),
                                              ),
                                              rightTitles: const AxisTitles(
                                                sideTitles: SideTitles(showTitles: false),
                                              ),
                                            ),
                                            borderData: FlBorderData(show: false),
                                            lineBarsData: [
                                              LineChartBarData(
                                                spots: chartSpots,
                                                isCurved: true,
                                                color: primaryColor,
                                                barWidth: 3,
                                                isStrokeCapRound: true,
                                                dotData: FlDotData(
                                                  show: true,
                                                  getDotPainter: (spot, percent, barData, index) =>
                                                      FlDotCirclePainter(
                                                    radius: 4,
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                    strokeColor: primaryColor,
                                                  ),
                                                ),
                                                belowBarData: BarAreaData(
                                                  show: true,
                                                  color: primaryColor.withValues(alpha: 0.1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.show_chart,
                                                size: 48,
                                                color: Colors.grey[300],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Add at least 2 records\nto see the chart',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Recent Logs
                          Text(
                            'Recent Logs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Show birth entry if no records but we have birth data
                          if (filteredRecords.isEmpty && ((showWeight && birthWeight != null) || (!showWeight && birthHeight != null)))
                            _buildLogItem(
                              '${(showWeight ? birthWeight : birthHeight)?.toStringAsFixed(1)} ${showWeight ? 'kg' : 'cm'}',
                              birthDate != null ? 'Birth - ${DateFormat('MMM d, yyyy').format(birthDate)}' : 'At Birth',
                              true,
                            )
                          else if (filteredRecords.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  showWeight ? 'No weight records yet' : 'No height records yet',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                              ),
                            )
                          else ...[
                            ...filteredRecords.take(10).map((record) => _buildLogItem(
                              '${(showWeight ? record.weight : record.height)?.toStringAsFixed(1)} ${showWeight ? 'kg' : 'cm'}',
                              DateFormat('MMM d, yyyy').format(record.recordedDate),
                              record == filteredRecords.first,
                            )),
                            // Add birth data as the last entry in the log if available
                            if ((showWeight && birthWeight != null) || (!showWeight && birthHeight != null))
                              _buildLogItem(
                                '${(showWeight ? birthWeight : birthHeight)?.toStringAsFixed(1)} ${showWeight ? 'kg' : 'cm'}',
                                birthDate != null ? 'Birth - ${DateFormat('MMM d, yyyy').format(birthDate)}' : 'At Birth',
                                false,
                              ),
                          ],
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecordDialog(context),
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildLogItem(String value, String date, bool isLatest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isLatest ? primaryColor.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLatest ? primaryColor : Colors.grey[300]!,
          width: isLatest ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: isLatest ? primaryColor : Colors.grey[400],
              ),
              const SizedBox(width: 12),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isLatest ? FontWeight.w600 : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            date,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showAddRecordDialog(BuildContext context) {
    _weightController.clear();
    _heightController.clear();
    _selectedDate = DateTime.now();
    
    // Capture the cubit reference BEFORE showing the dialog
    final babyCubit = context.read<BabyCubit>();
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFDF8FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'Add Growth Record',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: TextStyle(color: primaryColor),
                      hintText: 'e.g., 5.5',
                      prefixIcon: Icon(Icons.scale, color: primaryColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      labelStyle: TextStyle(color: primaryColor),
                      hintText: 'e.g., 65',
                      prefixIcon: Icon(Icons.straighten, color: primaryColor),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: builderContext,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setDialogState(() => _selectedDate = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(color: primaryColor),
                          hintText: DateFormat('MMM d, yyyy').format(_selectedDate),
                          prefixIcon: Icon(Icons.calendar_today, color: primaryColor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                        ),
                        controller: TextEditingController(
                          text: DateFormat('MMM d, yyyy').format(_selectedDate),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
                ),
                ElevatedButton(
                  onPressed: () {
                    final weight = double.tryParse(_weightController.text);
                    final height = double.tryParse(_heightController.text);
                    
                    if (weight != null || height != null) {
                      // Use the captured babyCubit reference
                      babyCubit.addGrowthRecord(
                        recordedDate: _selectedDate,
                        weight: weight,
                        height: height,
                      );
                      Navigator.pop(dialogContext);
                    } else {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(content: Text('Please enter at least one measurement')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
