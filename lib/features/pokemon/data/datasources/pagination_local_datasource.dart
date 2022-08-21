import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/pagination_model.dart';

abstract class PaginationLocalDataSource {
  ///Get the cached page [PaginationModel] between [0 - 20]
  ///This is gotten the first time the user had an internat connection.
  ///
  ///Throws [NoLocalDataException] if no cached data is present.
  Future<PaginationModel> getPagePagination();

  Future<void> cachePagePagination(PaginationModel page);
}

const String CACHED_PAGINATION = "CACHED_PAGINATION";

class PaginationLocalDataSourceImpl implements PaginationLocalDataSource {
  final SharedPreferences sharedPreferences;

  PaginationLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<PaginationModel> getPagePagination() async {
    final String? jsonString = sharedPreferences.getString(CACHED_PAGINATION);
    if (jsonString != null) {
      return PaginationModel.fromJson(json.decode(jsonString));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cachePagePagination(PaginationModel page) async {
    if (!sharedPreferences.containsKey(CACHED_PAGINATION)) {
      await sharedPreferences.setString(
        CACHED_PAGINATION,
        json.encode(page.toJson()),
      );
    }

    return;
  }
}
