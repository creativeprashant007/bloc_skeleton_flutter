// import 'package:dresscamp/common/bloc/button/bloc.dart';
// import 'package:dresscamp/core/configs/routes/route_names.dart';
// import 'package:dresscamp/global/global.dart';
// import 'package:dresscamp/presentation/application/pages/application.dart';
// import 'package:dresscamp/presentation/auth/login/pages/login.dart';
// import 'package:dresscamp/presentation/auth/sign_up/pages/sign_up.dart';

// import 'package:dresscamp/presentation/welcome/bloc/bloc.dart';
// import 'package:dresscamp/presentation/welcome/pages/welcome.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AppRoutes {
//   static List<PageEntity> routes() {
//     return [
//       PageEntity(route: RouteNames.initial, page: WelcomePage()),
//       PageEntity(route: RouteNames.login, page: LoginPage()),
//       PageEntity(route: RouteNames.signUp, page: SignUp()),
//       PageEntity(route: RouteNames.application, page: ApplicationPage()),
//     ];
//   }

//   List<dynamic> allProviders(BuildContext context) {
//     List<dynamic> allBlocProviders = [
//       BlocProvider(create: (_) => ButtonBloc()),
//       BlocProvider(create: (_) => WelcomeBlocs()),
//     ];

//     return allBlocProviders;
//   }

//   static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {
//     if (settings.name != null) {
//       var result = routes().where((element) => element.route == settings.name);
//       if (result.isNotEmpty) {
//         bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();
//         if (result.first.route == RouteNames.initial && deviceFirstOpen) {
//           bool isLoggedIn = Global.storageService.getIsLoggedIn();
//           if (isLoggedIn) {
//             return MaterialPageRoute(
//               builder: (_) => Container(),
//               settings: settings,
//             );
//           }
//           return MaterialPageRoute(
//             builder: (_) => Container(),
//             settings: settings,
//           );
//         }
//         return MaterialPageRoute(
//           builder: (_) => result.first.page,
//           settings: settings,
//         );
//       }
//     }
//     return MaterialPageRoute(builder: (_) => Container(), settings: settings);
//   }
// }

// class PageEntity {
//   String route;
//   Widget page;

//   PageEntity({required this.route, required this.page});
// }
