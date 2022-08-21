# Pokemondo
![pokeball](https://user-images.githubusercontent.com/52233891/185772489-b1d62ef9-4d9b-4929-a96b-8c3f3a7ab3be.png)

A Flutter project to learn more about the Pokemon's world and can also serve as good practice reference for other flutter projects.

![Pokemon Pokemondo](https://user-images.githubusercontent.com/52233891/185772465-343d6906-6d5b-40e8-b4fb-ae81a1671b51.png)

## Run Project Instructions
1. download or clone the repository
2. install the latest version of flutter
3. open your terminal
4. move to the project root folder using your terminal
5. **run**: `flutter pub get`
6. make sure your phone is connected to your laptop/pc or your emulator is launched.
7. **run**: `flutter run`
8. Tests can be found at the **test** folder at the root of the project

## Frameworks
- Flutter version 3+

## Used Architecture
- The Clean Architecture

## Used libraries
- **mockito**: used to mock dependences needed for testing at the different app architecture layers. 
- **build_runner**: used to auto generate the Mockito Mocked Classes
- **flutter_bloc**: used for state management in the app at the presentation layer.
- **bloc_concurrency**: used as support to **flutter_bloc* to allow the excecution of process events concurrently
- **dartz**: for functional programming. for example it forces you to handle all possible reponses from a function call. 
- **equatable**: for value equality on Classes
- **get_it**: service locator for easily inject dependences to to Classes.
- **flex_color_scheme**: for app theming helped me add support for (light, and dark themes).
- **google_fonts**: help me add the Noto Sans fontFamily to the app as used on the Figma design.
- **flutter_localizations**: to add support for other languages in app.
- **intl**: helps me add my own localized messages for the app to support (both English and French).
- **flutter_native_splash**: to add spash screen support for native platform to reflect the one found in the Figma design file.
- **internet_connection_checker**: used as an implementation of the app core NetworkInfo abstract class to check if the device has access to internet connection. 
- **shared_preferences**: helps to save locally users prefered (Theme, language). and also to cache some previously loaded Pokemons data.
- **palette_generator**: used by the function imageColors to dynamically indentify pokemons sprite image colors. to then used it on the Pokemon UI Card.
- **cached_network_image**: used to display network images to the user. It is optimize to cache loaded images and display them whenever there is no internet access and also loads images more faster once it was already cached whcih reduceses the unneccassary image request to the server whenever there is internet access.
