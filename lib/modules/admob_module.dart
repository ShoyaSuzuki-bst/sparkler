import 'dart:io';

class AdmobModule {
  static String getTestAdBannerUnitId() {
    String testBannerUnitId = "";
    if (Platform.isAndroid) {
      // Android のとき
      testBannerUnitId = "ca-app-pub-3940256099942544/6300978111"; // Androidのデモ用バナー広告ID
    } else if (Platform.isIOS) {
      // iOSのとき
      testBannerUnitId = "ca-app-pub-3940256099942544/6300978111"; // iOSのデモ用バナー広告ID
    }
    return testBannerUnitId;
  }

  static String getAdBannerUnitId() {
    String bannerUnitId = "";
    if (Platform.isAndroid) {
      // Android のとき
      bannerUnitId = "ca-app-pub-3940256099942544/6300978111"; // Androidの本番環境用バナー広告ID
    } else if (Platform.isIOS) {
      // iOSのとき
      bannerUnitId = "ca-app-pub-1782649289767849/2597243528"; // iOSの本番環境用バナー広告ID
    }
    return bannerUnitId;
  }
}
