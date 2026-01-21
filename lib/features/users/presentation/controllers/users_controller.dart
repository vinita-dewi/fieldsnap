import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/core/logging/app_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_users.dart';

class UsersController extends GetxController {
  UsersController({required this.getUsers});

  final GetUsers getUsers;
  final _log = AppLogger.instance;

  final RxList<UserProfile> _users = <UserProfile>[].obs;
  List<UserProfile> get users => _users.value;

  final Rx<FetchState> _fetchState = FetchState.idle.obs;
  FetchState get fetchState => _fetchState.value;

  final ScrollController scroll = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    scroll.addListener(() async {
      if (scroll.position.atEdge &&
          scroll.position.pixels != 0 &&
          _fetchState.value != FetchState.fetching) {
        _log.i('[UsersController] Scroll reached end');
        await fetchUsers(isFetching: true);
      }
    });
  }

  Future<void> fetchUsers({int limit = 20, bool isFetching = false}) async {
    try {
      _fetchState.value = isFetching ? FetchState.fetching : FetchState.loading;
      List<UserProfile> tempUsers = await getUsers(
        GetUsersParams(limit: limit, skip: _users.length),
      );
      if (_users.isEmpty) {
        _users.value = tempUsers;
      } else {
        _users.addAll(tempUsers);
      }
      _log.i('[UsersController.fetchUsers] count=${_users.length}');
    } catch (e) {
      _log.e('[UsersController.fetchUsers] $e');
    } finally {
      _fetchState.value = FetchState.idle;
    }
  }
}
