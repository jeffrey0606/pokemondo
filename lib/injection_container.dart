import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/pokemon/data/datasources/pagination_local_datasource.dart';
import 'features/pokemon/data/datasources/pagination_remote_datasource.dart';
import 'features/pokemon/data/datasources/pokemon_local_datasource.dart';
import 'features/pokemon/data/datasources/pokemon_remote_datasource.dart';
import 'features/pokemon/data/repositories/pagination_repository_impl.dart';
import 'features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'features/pokemon/domain/repositories/pagination_repository.dart';
import 'features/pokemon/domain/repositories/pokemon_repository.dart';
import 'features/pokemon/domain/usecases/get_favourites.dart';
import 'features/pokemon/domain/usecases/get_page.dart';
import 'features/pokemon/domain/usecases/get_pokemon.dart';
import 'features/pokemon/domain/usecases/remove_from_favourites.dart';
import 'features/pokemon/domain/usecases/save_to_favourites.dart';
import 'features/pokemon/presentation/favourites_bloc/bloc/favourites_bloc.dart';
import 'features/pokemon/presentation/pagination_bloc/bloc/pagination_bloc.dart';
import 'features/pokemon/presentation/pokemon_bloc/bloc/pokemon_bloc.dart';

final serviceLocator = GetIt.asNewInstance();

Future<void> initServices() async {
  //! Features - Pokemon
  // Bloc
  serviceLocator.registerFactory<PokemonBloc>(
    () => PokemonBloc(getPokemon: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<PaginationBloc>(
    () => PaginationBloc(getPage: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<FavouritesBloc>(
    () => FavouritesBloc(
      getFavourites: serviceLocator(),
      removeFromFavourites: serviceLocator(),
      saveToFavourites: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator.registerLazySingleton<GetPage>(
    () => GetPage(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetPokemon>(
    () => GetPokemon(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetFavourites>(
    () => GetFavourites(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<RemoveFromFavourites>(
    () => RemoveFromFavourites(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<SaveToFavourites>(
    () => SaveToFavourites(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(
      pokemonRemoteDataSource: serviceLocator(),
      pokemonLocalDataSource: serviceLocator(),
      networknfo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<PaginationRepository>(
    () => PaginationRepositoryImpl(
      paginationRemoteDataSource: serviceLocator(),
      paginationLocalDataSource: serviceLocator(),
      networknfo: serviceLocator(),
    ),
  );

  //Data Sources
  serviceLocator.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(
      client: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<PaginationRemoteDataSource>(
    () => PaginationRemoteDataSourceImpl(client: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<PaginationLocalDataSource>(
    () => PaginationLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  );

  //! Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  serviceLocator.registerLazySingleton(() => http.Client());

  serviceLocator.registerLazySingleton(() => InternetConnectionChecker.createInstance(
    checkTimeout: const Duration(seconds: 1),
    checkInterval: const Duration(seconds: 1),
  ));
}
