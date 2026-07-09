import 'package:equatable/equatable.dart';
import 'package:gestanea/core/database/models/baby_model.dart';
import 'package:gestanea/core/database/models/baby_growth_model.dart';
import 'package:gestanea/core/database/models/milestone_model.dart';
import 'package:gestanea/core/database/models/feeding_log_model.dart';

abstract class BabyState extends Equatable {
  const BabyState();

  @override
  List<Object?> get props => [];
}

class BabyInitial extends BabyState {}

class BabyLoading extends BabyState {}

class BabyLoaded extends BabyState {
  final BabyModel baby;
  final List<BabyGrowthModel> growthRecords;
  final List<MilestoneModel> milestones;
  final List<FeedingLogModel> feedingLogs;
  final BabyGrowthModel? latestGrowth;

  const BabyLoaded({
    required this.baby,
    this.growthRecords = const [],
    this.milestones = const [],
    this.feedingLogs = const [],
    this.latestGrowth,
  });

  @override
  List<Object?> get props => [
    baby,
    growthRecords,
    milestones,
    feedingLogs,
    latestGrowth,
  ];

  BabyLoaded copyWith({
    BabyModel? baby,
    List<BabyGrowthModel>? growthRecords,
    List<MilestoneModel>? milestones,
    List<FeedingLogModel>? feedingLogs,
    BabyGrowthModel? latestGrowth,
  }) {
    return BabyLoaded(
      baby: baby ?? this.baby,
      growthRecords: growthRecords ?? this.growthRecords,
      milestones: milestones ?? this.milestones,
      feedingLogs: feedingLogs ?? this.feedingLogs,
      latestGrowth: latestGrowth ?? this.latestGrowth,
    );
  }
}

class NoBabyProfile extends BabyState {}

class BabyError extends BabyState {
  final String message;

  const BabyError(this.message);

  @override
  List<Object?> get props => [message];
}

// Growth Tracker specific states
class GrowthLoading extends BabyState {}

class GrowthLoaded extends BabyState {
  final List<BabyGrowthModel> growthRecords;
  final BabyGrowthModel? latestGrowth;

  const GrowthLoaded({required this.growthRecords, this.latestGrowth});

  @override
  List<Object?> get props => [growthRecords, latestGrowth];
}

// Milestone specific states
class MilestoneLoading extends BabyState {}

class MilestoneLoaded extends BabyState {
  final List<MilestoneModel> allMilestones;
  final List<MilestoneModel> achievedMilestones;
  final List<MilestoneModel> upcomingMilestones;

  const MilestoneLoaded({
    required this.allMilestones,
    required this.achievedMilestones,
    required this.upcomingMilestones,
  });

  @override
  List<Object?> get props => [
    allMilestones,
    achievedMilestones,
    upcomingMilestones,
  ];
}

// Feeding Log specific states
class FeedingLoading extends BabyState {}

class FeedingLoaded extends BabyState {
  final List<FeedingLogModel> feedingLogs;
  final Map<String, dynamic>? stats;
  final String selectedType; // 'All', 'Breastfeed', 'Bottle'

  const FeedingLoaded({
    required this.feedingLogs,
    this.stats,
    this.selectedType = 'All',
  });

  @override
  List<Object?> get props => [feedingLogs, stats, selectedType];

  FeedingLoaded copyWith({
    List<FeedingLogModel>? feedingLogs,
    Map<String, dynamic>? stats,
    String? selectedType,
  }) {
    return FeedingLoaded(
      feedingLogs: feedingLogs ?? this.feedingLogs,
      stats: stats ?? this.stats,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

// Operation states
class BabyOperationSuccess extends BabyState {
  final String message;

  const BabyOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
