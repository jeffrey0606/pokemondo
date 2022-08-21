import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemondo/core/utils/constants.dart';
import 'package:pokemondo/core/utils/enums.dart';
import 'package:pokemondo/core/widgets/loader.dart';
import 'package:pokemondo/features/pokemon/presentation/favourites_bloc/bloc/favourites_bloc.dart';
import 'package:pokemondo/features/pokemon/presentation/widgets/pokemon_card_blocbuilder.dart';
import 'package:pokemondo/injection_container.dart';
import '../pagination_bloc/bloc/pagination_bloc.dart';

class AllPokemonsPage extends StatefulWidget {
  const AllPokemonsPage({Key? key}) : super(key: key);

  @override
  State<AllPokemonsPage> createState() => _AllPokemonsPageState();
}

class _AllPokemonsPageState extends State<AllPokemonsPage> {
  final ScrollController _controller = ScrollController();

  void dispatchPagination(
    String url, {
    bool wait = false,
  }) {
    BlocProvider.of<PaginationBloc>(context).add(
      GetPaginationPage(url, wait: wait),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginationBloc, PaginationState>(
      builder: (context, state) {
        if (state.status == PaginationStatus.initial) {
          return Container();
        } else if (state.status == PaginationStatus.loading &&
            state.namedPokemons.isEmpty) {
          return const Loader(
            height: 60,
            width: 60,
          );
        } else if (state.status == PaginationStatus.failed &&
            state.namedPokemons.isEmpty) {
          return showRetryWidget(
            state,
            context,
          );
        } else if (state.status == PaginationStatus.loaded ||
            (state.status == PaginationStatus.loading &&
                state.namedPokemons.isNotEmpty)) {
          
          final bool isStillLoading = state.status == PaginationStatus.loading;
          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter == 0 &&
                  state.status == PaginationStatus.loaded) {
                if (state.nextUrl != null) {
                  dispatchPagination(
                    state.nextUrl!,
                    wait: true,
                  );

                  log("load more...");

                  // Future.sync(() async {
                  //   await Future.delayed(
                  //     const Duration(milliseconds: 300),
                  //   );
                  //   _controller.animateTo(
                  //     _controller.position.maxScrollExtent,
                  //     curve: Curves.linear,
                  //     duration: const Duration(
                  //       milliseconds: 100,
                  //     ),
                  //   );
                  // });
                }
              }

              return false;
            },
            child: CustomScrollView(
              // controller: _controller,
              slivers: [
                pokemonsGridView(
                  state,
                ),
                refreshLoader(
                  isStillLoading,
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  SliverPadding pokemonsGridView(PaginationState state) {
    return SliverPadding(
      padding: GRID_PADDING,
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return LayoutBuilder(builder: (context, constraints) {
              log("Size: ${constraints.maxHeight}x${constraints.maxWidth}");
              return PokemonCardBlocBuilder(
                namedPokemon: state.namedPokemons[index],
              );
            });
          },
          childCount: state.namedPokemons.length,
        ),
        gridDelegate: GRID_DELEGATE,
      ),
    );
  }

  SliverToBoxAdapter refreshLoader(bool isStillLoading) {
    return SliverToBoxAdapter(
      child: isStillLoading
          ? SizedBox(
              height: isStillLoading ? 100 : 0,
              width: double.infinity,
              child: const Loader(
                height: 35,
                width: 35,
              ),
            )
          : Container(),
    );
  }

  Column showRetryWidget(PaginationState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            state.error.message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextButton(
          onPressed: () {
            serviceLocator<PaginationBloc>().add(
              const GetPaginationPage(
                FRIST_PAGE_URL,
                wait: true,
              ),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: const Text(
            "Retry",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
