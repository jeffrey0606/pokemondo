import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/pagination.dart';
import '../repositories/pagination_repository.dart';

class GetPage extends UseCase<Pagination, Params> {
  final PaginationRepository repository;

  GetPage(this.repository);

  @override
  Future<Either<Failure, Pagination>> call(Params params) async {
    return await repository.getPage(params.url);
  }
}

class Params extends Equatable {
  final String url;

  const Params({
    required this.url,
  });

  @override
  List<Object?> get props => [url];
}
