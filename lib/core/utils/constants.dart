import 'package:flutter/material.dart';

const GRID_DELEGATE = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 180,
  childAspectRatio: 0.703125,
  crossAxisSpacing: 10,
  mainAxisSpacing: 12,
);

const GRID_PADDING = EdgeInsets.symmetric(
  horizontal: 12,
  vertical: 16,
);

const String FRIST_PAGE_URL = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0";