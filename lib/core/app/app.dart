import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/pokemon/presentation/favourites_bloc/bloc/favourites_bloc.dart';
import '../../features/pokemon/presentation/pagination_bloc/bloc/pagination_bloc.dart';
import '../../injection_container.dart';
import '../utils/constants.dart';
import '../utils/show_toast.dart';
import 'app_layout.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    APP_ROOT_BIULD_CONTEXT = context;
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavouritesBloc>(
          create: (_) =>
              serviceLocator<FavouritesBloc>()..add(GetAllFavourites()),
        ),
        BlocProvider<PaginationBloc>(
          create: (_) => serviceLocator<PaginationBloc>()
            ..add(
              const GetPaginationPage(
                FRIST_PAGE_URL,
                wait: true,
              ),
            ),
        ),
      ],
      child: const AppLayout(),
    );
  }
}
