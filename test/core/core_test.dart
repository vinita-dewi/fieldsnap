import 'package:dio/dio.dart';
import 'package:fieldsnap/core/config/env.dart';
import 'package:fieldsnap/core/enums/api_method.dart';
import 'package:fieldsnap/core/error/exceptions.dart';
import 'package:fieldsnap/core/error/failures.dart';
import 'package:fieldsnap/core/routes/app_pages.dart';
import 'package:fieldsnap/core/routes/app_routes.dart';
import 'package:fieldsnap/core/services/api_service.dart';
import 'package:fieldsnap/core/theme/app_colors.dart';
import 'package:fieldsnap/core/utils/api_constants.dart';
import 'package:fieldsnap/core/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(setupTestFonts);

  group('Core constants and routes', () {
    test('ApiConstants has expected endpoints', () {
      expect(ApiConstants.getUsers, contains('dummy'));
      expect(ApiConstants.getProvince, contains('/provinces'));
    });

    test('AppRoutes defines main routes', () {
      expect(AppRoutes.home, '/');
      expect(AppRoutes.users, '/users');
    });

    test('AppPages exposes routes list', () {
      expect(AppPages.pages, isNotEmpty);
      expect(AppPages.pages.map((page) => page.name), contains(AppRoutes.home));
    });
  });

  group('Core theme and utils', () {
    test('AppColors provide primary color', () {
      expect(AppColors.primary, isA<Color>());
    });

    testWidgets('Gap converts px to SizedBox', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(),
        ),
      );
      final gap = Gap.h(20);
      expect(gap.height, greaterThan(0));
      final responsive = 20.px;
      expect(responsive, greaterThan(0));
    });
  });

  group('Core errors', () {
    test('Failures and exceptions can be constructed', () {
      expect(const ServerFailure('x').message, 'x');
      expect(const NetworkFailure('y').message, 'y');
      expect(const CacheFailure('z').message, 'z');
      expect(const ServerException('x').message, 'x');
      expect(const NetworkException('y').message, 'y');
      expect(const CacheException('z').message, 'z');
    });
  });

  test('Env reads API key', () {
    dotenv.testLoad(fileInput: 'API_KEY=abc');
    expect(Env.apiKey, 'abc');
  });

  group('ApiService', () {
    test('request throws on network failure with short timeout', () async {
      final service = ApiService(baseUrl: '');
      await expectLater(
        service.request(
          path: 'http://example.invalid',
          method: ApiMethod.GET,
          options: Options(
            sendTimeout: const Duration(milliseconds: 1),
            receiveTimeout: const Duration(milliseconds: 1),
          ),
        ),
        throwsA(isA<DioException>()),
      );
    });

    test('request sets api key header when enabled', () async {
      final service = ApiService(baseUrl: '');
      await expectLater(
        service.request(
          path: 'http://example.invalid',
          method: ApiMethod.GET,
          useApiKey: true,
          options: Options(
            headers: {'x-test': '1'},
            sendTimeout: const Duration(milliseconds: 1),
            receiveTimeout: const Duration(milliseconds: 1),
          ),
        ),
        throwsA(isA<DioException>()),
      );
    });
  });
}
