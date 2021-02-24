
enum Routes{HOME, DETAILS, VIEWER}

extension RoutesExtension on Routes{

  String get path{
    switch(this)
    {
      case Routes.HOME : return '/';
      case Routes.DETAILS : return '/details';
      case Routes.VIEWER : return '/viewer';
      default : return null;
    }
  }

}