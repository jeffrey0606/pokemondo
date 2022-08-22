import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemondo/core/ads/ads_state.dart';
import 'package:pokemondo/core/widgets/my_banner_ad.dart';
import 'package:pokemondo/features/pokemon/presentation/widgets/show_dialog.dart';

import '../../features/pokemon/presentation/favourites_bloc/bloc/favourites_bloc.dart';
import '../../features/pokemon/presentation/pages/all_pokemons_page.dart';
import '../../features/pokemon/presentation/pages/favourites_page.dart';
import '../../features/pokemon/presentation/widgets/switch_language.dart';
import '../../features/pokemon/presentation/widgets/switch_theme.dart';
import '../custom_paints/custom_tab_indicator_decoration.dart';
import '../utils/enums.dart';
import '../utils/extensions.dart';
import '../widgets/app_title.dart';
import '../widgets/custom_badge.dart';
import '../widgets/display_icon.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<AppLayout> createState() => AppLayoutState();
}

class AppLayoutState extends State<AppLayout>
    with SingleTickerProviderStateMixin {
  final bool _pinned = true;

  final bool _snap = false;

  final bool _floating = true;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: 0,
      length: AppTabs.values.length,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                centerTitle: true,
                title: const AppTitle(),
                pinned: _pinned,
                snap: _snap,
                floating: _floating,
                elevation: 1,
                bottom: PreferredSize(
                  preferredSize: Size(
                    double.infinity,
                    AppBar().preferredSize.height,
                  ),
                  child: SizedBox(
                    height: AppBar().preferredSize.height,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.05),
                            width: 2,
                          ),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        // indicatorColor: Theme.of(context).colorScheme.secondary,
                        // indicatorSize: TabBarIndicatorSize,
                        // indicatorWeight: 0,
                        // labelColor: ,
                        indicator: MyTabIndicator(
                          height: 4,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        tabs: [
                          Tab(
                            child: tabText(
                              context,
                              AppTabs.allPokemons.translate(context),
                              AppTabs.allPokemons.index == _tabController.index,
                            ),
                          ),
                          Tab(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                tabText(
                                  context,
                                  AppTabs.favourites.translate(context),
                                  AppTabs.favourites.index ==
                                      _tabController.index,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                BlocSelector<FavouritesBloc, FavouritesState,
                                    int>(
                                  selector: (state) {
                                    return state.pokemons.length;
                                  },
                                  builder: (context, favouriteCount) {
                                    if (favouriteCount <= 0) {
                                      return Container();
                                    }
                                    return CustomBadge(
                                      value: favouriteCount,
                                      fontSize: 12,
                                      padding: 3,
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [
              AllPokemonsPage(),
              FavouritesPage(),
            ],
          ),
        ),
      ),
      // bottomSheet: Container(
      //   height: 50,
      // ),
      bottomNavigationBar: MyBannarAd(adUnit: AdState.homePageAdUnitId),
      floatingActionButton: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        color: Theme.of(context).colorScheme.primary,
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          width: 120,
          child: ButtonBar(
            children: [
              IconButton(
                onPressed: () {
                  showMyDialog(context, DialogType.lang);
                },
                splashRadius: 28,
                splashColor: Theme.of(context).backgroundColor.withOpacity(1),
                highlightColor:
                    Theme.of(context).backgroundColor.withOpacity(1),
                icon: DisplayIcon(
                  icon: Icons.language_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              IconButton(
                onPressed: () {
                  showMyDialog(context, DialogType.theme);
                },
                splashRadius: 28,
                splashColor: Theme.of(context).backgroundColor.withOpacity(1),
                highlightColor:
                    Theme.of(context).backgroundColor.withOpacity(1),
                icon: DisplayIcon(
                  icon: Icons.sunny,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text tabText(BuildContext context, String text, bool isSelected) {
    return Text(
      text,
      style: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: isSelected
                ? Theme.of(context).textTheme.headline1!.color
                : null,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w500 : null,
          ),
    );
  }
}
