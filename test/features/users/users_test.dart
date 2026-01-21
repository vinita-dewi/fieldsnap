import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/features/users/data/datasources/user_local_datasource.dart';
import 'package:fieldsnap/features/users/data/datasources/user_remote_datasource.dart';
import 'package:fieldsnap/features/users/data/repositories/user_repository_impl.dart';
import 'package:fieldsnap/features/users/domain/entities/company.dart';
import 'package:fieldsnap/features/users/domain/entities/user_profile.dart';
import 'package:fieldsnap/features/users/domain/models/company_model.dart';
import 'package:fieldsnap/features/users/domain/models/user_profile_model.dart';
import 'package:fieldsnap/features/users/domain/repositories/user_repository.dart';
import 'package:fieldsnap/features/users/domain/usecases/get_users.dart';
import 'package:fieldsnap/features/users/presentation/controllers/users_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fakes.dart';

class _FakeUserRemoteDataSource implements UserRemoteDataSource {
  _FakeUserRemoteDataSource(this.models);
  final List<UserProfileModel> models;

  @override
  Future<List<UserProfileModel>> getUsers({
    required int limit,
    required int skip,
  }) async {
    return models.skip(skip).take(limit).toList();
  }
}

class _ThrowingUserRemoteDataSource implements UserRemoteDataSource {
  @override
  Future<List<UserProfileModel>> getUsers({
    required int limit,
    required int skip,
  }) async {
    throw Exception('fail');
  }
}

class _FakeUserLocalDataSource implements UserLocalDataSource {
  @override
  Future<List<UserProfile>> getUsers({
    required int limit,
    required int skip,
  }) async {
    return <UserProfile>[];
  }
}

class _FakeUserRepository implements UserRepository {
  _FakeUserRepository(this.items);
  final List<UserProfile> items;

  @override
  Future<List<UserProfile>> getUsers({
    required int limit,
    required int skip,
  }) async {
    return items.skip(skip).take(limit).toList();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('User models', () {
    test('CompanyModel maps to entity', () {
      final model = CompanyModel.fromJson({
        'name': 'Acme',
        'department': 'Eng',
        'title': 'Dev',
        'address': {
          'address': 'Street 1',
          'city': 'City',
          'state': 'State',
          'country': 'ID',
          'postalCode': '12345',
        },
      });
      final entity = model.toEntity();
      expect(entity.name, 'Acme');
      expect(entity.address, contains('Street 1'));
    });

    test('UserProfileModel maps response to entity', () {
      final model = UserProfileModel.fromJson({
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'maidenName': 'Smith',
        'age': 29,
        'gender': 'female',
        'email': 'emily@example.com',
        'phone': '123',
        'university': 'Uni',
        'image': 'img',
        'company': {
          'name': 'Acme',
          'department': 'Eng',
          'title': 'Dev',
          'address': {
            'address': 'Street 1',
            'city': 'City',
            'state': 'State',
            'country': 'ID',
            'postalCode': '12345',
          },
        },
        'address': {
          'address': 'Street 1',
          'city': 'City',
          'state': 'State',
          'country': 'ID',
          'postalCode': '12345',
        },
      });
      final entity = model.toEntity();
      expect(entity.completeName, 'Emily Johnson');
      expect(entity.gender, UserGender.female);
      expect(entity.company.name, 'Acme');
      expect(entity.completeAddress, contains('City'));
    });
  });

  group('UserRemoteDataSource', () {
    test('parses users list', () async {
      final api = FakeApiService({
        'users': [
          {
            'firstName': 'Emily',
            'lastName': 'Johnson',
            'maidenName': 'Smith',
            'age': 29,
            'gender': 'female',
            'email': 'emily@example.com',
            'phone': '123',
            'university': 'Uni',
            'image': 'img',
            'company': {
              'name': 'Acme',
              'department': 'Eng',
              'title': 'Dev',
              'address': {
                'address': 'Street 1',
                'city': 'City',
                'state': 'State',
                'country': 'ID',
                'postalCode': '12345',
              },
            },
            'address': {
              'address': 'Street 1',
              'city': 'City',
              'state': 'State',
              'country': 'ID',
              'postalCode': '12345',
            },
          },
        ],
      });
      final dataSource = UserRemoteDataSourceImpl(api);
      final users = await dataSource.getUsers(limit: 20, skip: 0);
      expect(users.length, 1);
      expect(users.first.completeName, 'Emily Johnson');
    });

    test('rethrows errors', () async {
      final api = FakeApiService(null, throwError: true);
      final dataSource = UserRemoteDataSourceImpl(api);
      await expectLater(
        dataSource.getUsers(limit: 20, skip: 0),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('UserRepositoryImpl', () {
    test('maps models to entities', () async {
      final models = [
        UserProfileModel(
          completeName: 'Emily Johnson',
          maidenName: 'Smith',
          age: 29,
          gender: UserGender.female,
          email: 'emily@example.com',
          phone: '123',
          completeAddress: 'Street 1',
          university: 'Uni',
          company: const CompanyModel(
            name: 'Acme',
            department: 'Eng',
            title: 'Dev',
            address: 'Street 1',
          ),
          image: 'img',
        ),
      ];
      final repo = UserRepositoryImpl(
        localDataSource: _FakeUserLocalDataSource(),
        remoteDataSource: _FakeUserRemoteDataSource(models),
      );
      final entities = await repo.getUsers(limit: 20, skip: 0);
      expect(entities.first.company, isA<Company>());
      expect(entities.first.company.name, 'Acme');
    });

    test('rethrows errors from remote', () async {
      final repo = UserRepositoryImpl(
        localDataSource: _FakeUserLocalDataSource(),
        remoteDataSource: _ThrowingUserRemoteDataSource(),
      );
      await expectLater(
        repo.getUsers(limit: 1, skip: 0),
        throwsA(isA<Exception>()),
      );
    });
  });

  test('UserLocalDataSourceImpl throws', () async {
    final ds = UserLocalDataSourceImpl();
    await expectLater(ds.getUsers(limit: 1, skip: 0), throwsUnimplementedError);
  });

  group('UsersController', () {
    test('fetchUsers updates list and state', () async {
      final user = UserProfile(
        completeName: 'Emily Johnson',
        maidenName: 'Smith',
        age: 29,
        gender: UserGender.female,
        email: 'emily@example.com',
        phone: '123',
        completeAddress: 'Street 1',
        university: 'Uni',
        company: const Company(
          name: 'Acme',
          department: 'Eng',
          title: 'Dev',
          address: 'Street 1',
        ),
        image: 'img',
      );
      final controller = UsersController(
        getUsers: GetUsers(_FakeUserRepository([user])),
      );
      await controller.fetchUsers(limit: 1);
      expect(controller.fetchState, FetchState.idle);
      expect(controller.users.length, 1);
    });
  });

  test('GetUsers usecase delegates to repository', () async {
    final user = UserProfile(
      completeName: 'Emily Johnson',
      maidenName: 'Smith',
      age: 29,
      gender: UserGender.female,
      email: 'emily@example.com',
      phone: '123',
      completeAddress: 'Street 1',
      university: 'Uni',
      company: const Company(
        name: 'Acme',
        department: 'Eng',
        title: 'Dev',
        address: 'Street 1',
      ),
      image: 'img',
    );
    final usecase = GetUsers(_FakeUserRepository([user]));
    final result = await usecase(const GetUsersParams(limit: 1, skip: 0));
    expect(result.first.completeName, 'Emily Johnson');
  });

}
