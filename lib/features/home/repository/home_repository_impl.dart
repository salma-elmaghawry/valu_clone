import 'package:dartz/dartz.dart';
import 'package:no_wait/core/error_handling/error_mapper.dart';
import 'package:no_wait/core/error_handling/failures.dart';
import 'package:no_wait/features/home/data/datasource/home_remote_datasource.dart';
import 'package:no_wait/features/home/domain/entities/home_summary.dart';
import 'package:no_wait/features/home/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, HomeSummary>> getHomeSummary() async {
    try {
      final model = await _remoteDataSource.getHomeSummary();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ErrorMapper.map(e));
    }
  }
}
