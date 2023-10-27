import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wizedo/pages/HomePage.dart';
import 'package:wizedo/pages/LoginPage.dart';
import 'package:wizedo/pages/PostPage.dart';
import 'package:wizedo/pages/RegisterPage.dart';
import 'package:wizedo/pages/UserDetailsPage.dart';
import 'package:wizedo/pages/settings.dart';

import '../pages/detailsPage.dart';

class BottomNavigationController extends GetxController {
  RxInt index=0.obs;

  var pages=[
    HomePage(),
    UserDetails(),
    DetailsScreen(),
    settingScreen(),
  ];
}
