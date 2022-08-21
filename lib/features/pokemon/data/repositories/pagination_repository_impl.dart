import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/pagination.dart';
import '../../domain/repositories/pagination_repository.dart';
import '../datasources/pagination_local_datasource.dart';
import '../datasources/pagination_remote_datasource.dart';
import '../models/pagination_model.dart';

class PaginationRepositoryImpl extends PaginationRepository {
  final PaginationRemoteDataSource paginationRemoteDataSource;
  final PaginationLocalDataSource paginationLocalDataSource;
  final NetworkInfo networknfo;
  PaginationRepositoryImpl({
    required this.paginationRemoteDataSource,
    required this.paginationLocalDataSource,
    required this.networknfo,
  });

  @override
  Future<Either<Failure, Pagination>> getPage(String url) async {
    if (await networknfo.isConnected) {
      try {
        final PaginationModel paginationModel =
            await paginationRemoteDataSource.getPage(url);
        await paginationLocalDataSource.cachePagePagination(paginationModel);
        return Right(paginationModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final PaginationModel paginationModel =
            await paginationLocalDataSource.getPagePagination();

        return Right(paginationModel.fromCache());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
