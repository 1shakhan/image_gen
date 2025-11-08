enum AppPage {
  unknown('not-found'),

  prompt('prompt'),

  result('result');

  final String pathName;

  const AppPage(this.pathName);

  String get location => '/$pathName';
}