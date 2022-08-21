part of 'favourites_bloc.dart';

class FavouritesState extends Equatable {
  final List<Pokemon> pokemons;
  final FavouritesStatus status;
  final FavouritesActionStatus actionStatus;
  final Error error;

  const FavouritesState({
    this.pokemons = const [],
    this.status = FavouritesStatus.initial,
    this.actionStatus = FavouritesActionStatus.inactive,
    this.error = const Error.no(),
  });

  FavouritesState copyWith({
    FavouritesStatus Function()? status,
    FavouritesActionStatus Function()? actionStatus,
    List<Pokemon> Function()? pokemons,
    Error Function()? error,
  }) {
    if (error != null) {
      showToast(message: error().message, type: ToastMessageType.error);
    }

    if (actionStatus != null) {
      log("message");
      if (actionStatus() == FavouritesActionStatus.adding) {
        showToast(
            message: "Adding to favourites...", type: ToastMessageType.info);
      } else if (actionStatus() == FavouritesActionStatus.removing) {
        showToast(
            message: "Removing from favourites...",
            type: ToastMessageType.info);
      } else if (actionStatus() == FavouritesActionStatus.failed) {
        if (this.actionStatus == FavouritesActionStatus.adding) {
          showToast(
              message: "Failed to add to favourites",
              type: ToastMessageType.error);
        } else if (this.actionStatus == FavouritesActionStatus.removing) {
          showToast(
              message: "Failed to add to remove from favourites",
              type: ToastMessageType.error);
        }
      } else {
        //iniactive

        if (pokemons != null && pokemons().isEmpty) {
          showToast(
              message: "No Favourite Pokemon saved!",
              type: ToastMessageType.success);
        } else if (this.actionStatus == FavouritesActionStatus.adding) {
          showToast(
              message: "Pokemon Added to favourites Successfully!",
              type: ToastMessageType.success);
        } else if (this.actionStatus == FavouritesActionStatus.removing) {
          showToast(
              message: "Pokemon Removed from favourites Successfully!",
              type: ToastMessageType.success);
        }
      }
    }

    return FavouritesState(
      status: status != null ? status() : this.status,
      actionStatus: actionStatus != null ? actionStatus() : this.actionStatus,
      pokemons: pokemons != null ? pokemons() : this.pokemons,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object> get props => [pokemons, status, actionStatus, error];
}

class Error extends Equatable {
  final String message;

  const Error(this.message);

  const Error.no() : message = "";

  @override
  List<Object> get props => [message];
}
