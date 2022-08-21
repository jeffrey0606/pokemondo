import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../models/pagination_model.dart';

abstract class PaginationRemoteDataSource {
  ///Calls the https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20 endpoint.
  ///
  ///Throws a [ServerException] for all error codes.
  Future<PaginationModel> getPage(String url);
}

class PaginationRemoteDataSourceImpl implements PaginationRemoteDataSource {
  final http.Client client;

  PaginationRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<PaginationModel> getPage(String url) async {
    try {
      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return PaginationModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
