import 'package:gestanea/features/baby/logic/cubit/baby_cubit.dart';
import 'package:gestanea/features/baby/logic/repositories/baby_repository.dart';
import 'package:gestanea/features/baby/data/datasources/baby_local_data_source.dart';
import 'package:gestanea/core/database/db_helper.dart';

class BabyCubitFactory {
  static BabyCubit create(String userId) {
    final repository = BabyRepository(
      BabyLocalDataSource(DatabaseHelper.instance),
    );
    return BabyCubit(repository: repository, userId: userId);
  }
}
