import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/pagination.dart';

abstract class PaginationRepository {
  Future<Either<Failure, Pagination>> getPage(String url);
}
