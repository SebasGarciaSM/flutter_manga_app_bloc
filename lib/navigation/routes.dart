
enum Routes{LOGIN, HOME, DETAILS, VIEWER}

extension RoutesExtension on Routes{

  String get path{
    switch(this)
    {
      case Routes.LOGIN : return '/login';
      case Routes.HOME : return '/home';
      case Routes.DETAILS : return '/details';
      case Routes.VIEWER : return '/viewer';
      default : return null;
    }
  }

}