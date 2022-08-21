// Mocks generated by Mockito 5.2.0 from annotations
// in pokemondo/test/features/pokemon/data/repositories/pagination_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:pokemondo/features/pokemon/data/datasources/pagination_local_datasource.dart'
    as _i5;
import 'package:pokemondo/features/pokemon/data/datasources/pagination_remote_datasource.dart'
    as _i3;
import 'package:pokemondo/features/pokemon/data/models/pagination_model.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakePaginationModel_0 extends _i1.Fake implements _i2.PaginationModel {}

/// A class which mocks [PaginationRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPaginationRemoteDataSource extends _i1.Mock
    implements _i3.PaginationRemoteDataSource {
  MockPaginationRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.PaginationModel> getPage(String? url) =>
      (super.noSuchMethod(Invocation.method(#getPage, [url]),
              returnValue:
                  Future<_i2.PaginationModel>.value(_FakePaginationModel_0()))
          as _i4.Future<_i2.PaginationModel>);
}

/// A class which mocks [PaginationLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockPaginationLocalDataSource extends _i1.Mock
    implements _i5.PaginationLocalDataSource {
  MockPaginationLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.PaginationModel> getPagePagination() =>
      (super.noSuchMethod(Invocation.method(#getPagePagination, []),
              returnValue:
                  Future<_i2.PaginationModel>.value(_FakePaginationModel_0()))
          as _i4.Future<_i2.PaginationModel>);
  @override
  _i4.Future<void> cachePagePagination(_i2.PaginationModel? page) =>
      (super.noSuchMethod(Invocation.method(#cachePagePagination, [page]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
}