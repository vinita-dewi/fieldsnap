import 'package:get/get.dart';
import 'package:fieldsnap/core/enums/fetch_state.dart';

class HomeController extends GetxController {
  final Rx<FetchState> _fetchState = FetchState.idle.obs;
  FetchState get fetchState => _fetchState.value;
  void setFetchState(FetchState state) => _fetchState.value = state;

  @override
  void onInit() {
    super.onInit();
  }
}
