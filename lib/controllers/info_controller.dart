import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoController extends GetxController {
  final RxString _version = ''.obs;
  String get version => _version.value;

  Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    _version.value = info.version;
  }
}
