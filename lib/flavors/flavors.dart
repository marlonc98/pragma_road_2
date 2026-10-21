enum Flavor { mock, dev, prod }

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.mock:
        return '[MOCK] Portal Remoto';
      case Flavor.dev:
        return '[DEV] Portal Remoto';
      case Flavor.prod:
        return 'Portal Remoto';
    }
  }
}
