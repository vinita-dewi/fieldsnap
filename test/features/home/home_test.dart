import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/features/home/data/datasources/home_local_datasource.dart';
import 'package:fieldsnap/features/home/data/repositories/home_repository_impl.dart';
import 'package:fieldsnap/features/home/domain/entities/home_action.dart';
import 'package:fieldsnap/features/home/domain/repositories/home_repository.dart';
import 'package:fieldsnap/features/home/domain/usecases/get_home_actions.dart';
import 'package:fieldsnap/features/home/presentation/controllers/home_controller.dart';
import 'package:fieldsnap/core/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeRepository implements HomeRepository {
  @override
  Future<List<HomeAction>> getActions() async {
    return const [HomeAction(label: 'Users', route: '/users')];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Home data/domain', () {
    test('HomeLocalDataSource throws', () async {
      final ds = HomeLocalDataSourceImpl();
      await expectLater(ds.getActions(), throwsUnimplementedError);
    });

    test('HomeRepositoryImpl throws', () async {
      final repo = HomeRepositoryImpl(HomeLocalDataSourceImpl());
      expect(() => repo.getActions(), throwsUnimplementedError);
    });

    test('GetHomeActions returns repository data', () async {
      final usecase = GetHomeActions(_FakeHomeRepository());
      final actions = await usecase(const NoParams());
      expect(actions.first.label, 'Users');
    });
  });

  group('HomeController', () {
    test('setFetchState updates state', () {
      final controller = HomeController();
      controller.setFetchState(FetchState.loading);
      expect(controller.fetchState, FetchState.loading);
    });
  });

}
