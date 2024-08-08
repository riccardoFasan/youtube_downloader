import 'package:get/get.dart';

class LifecycleService extends FullLifeCycleController with FullLifeCycleMixin {
  final RxBool _active = true.obs;
  bool get active => _active.value;

  @override
  void onDetached() {
    _active.value = false;
  }

  @override
  void onInactive() {
    _active.value = false;
  }

  @override
  void onPaused() {
    _active.value = false;
  }

  @override
  void onResumed() {
    _active.value = true;
  }

  @override
  void onHidden() {
    _active.value = false;
  }
}
