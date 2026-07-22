import 'package:dartz/dartz.dart';
import 'package:no_wait/core/error_handling/failures.dart';
import 'package:no_wait/features/home/domain/entities/home_summary.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeSummary>> getHomeSummary();
}
