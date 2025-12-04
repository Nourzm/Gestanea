import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/features/education/logic/education_cubit.dart';
import 'package:gestanea/features/education/logic/education_state.dart';

class EducationPage extends StatelessWidget {
  const EducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_1,
      appBar: AppBar(
        title: const Text(
          'Education & Tips',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9B7FDB),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<EducationCubit, EducationState>(
        builder: (context, state) {
          if (state is EducationLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9B7FDB),
              ),
            );
          }

          if (state is EducationError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<EducationCubit>().loadTips();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9B7FDB),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is EducationLoaded) {
            if (state.tips.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No tips available',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Check back later for helpful tips!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.tips.length,
              itemBuilder: (context, index) {
                final tip = state.tips[index];
                final isSaved = state.savedTips.any((t) => t.id == tip.id);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tip.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF9B7FDB),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E0F5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tip.category.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF9B7FDB),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isSaved
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: const Color(0xFF9B7FDB),
                              ),
                              onPressed: () {
                                context
                                    .read<EducationCubit>()
                                    .toggleSave(tip.id);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tip.content,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                        if (tip.stage != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                tip.stage!.replaceAll('_', ' ').toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: BlocBuilder<EducationCubit, EducationState>(
        builder: (context, state) {
          if (state is EducationLoaded && state.savedTips.isNotEmpty) {
            return FloatingActionButton.extended(
              onPressed: () {
                // TODO: Navigate to saved tips page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${state.savedTips.length} tips saved'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              backgroundColor: const Color(0xFF9B7FDB),
              icon: const Icon(Icons.bookmark),
              label: Text('Saved (${state.savedTips.length})'),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
