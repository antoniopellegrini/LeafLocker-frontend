String get apiHost {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  if (isProd) {
    return 'productionURL';
  }

  //development url
  return "http://10.0.2.2:5000";
}

String get leafApiHost {
  bool isProd = const bool.fromEnvironment('dart.vm.product');
  if (isProd) {
    return 'productionURL';
  }

  //development url
  return "http://10.0.2.2:5001";
}
