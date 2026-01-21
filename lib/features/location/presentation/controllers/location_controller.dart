import 'package:app_settings/app_settings.dart';
import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/core/logging/app_logger.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_city.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_district.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_postal.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_province.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_village.dart';
import 'package:fieldsnap/features/location/domain/entities/province.dart';
import 'package:fieldsnap/features/location/domain/entities/regency.dart';
import 'package:fieldsnap/features/location/domain/entities/district.dart';
import 'package:fieldsnap/features/location/domain/entities/village.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  LocationController({
    required this.getProvince,
    required this.getRegency,
    required this.getDistrict,
    required this.getVillage,
    required this.getPostal,
  });

  final GetProvince getProvince;
  final GetRegency getRegency;
  final GetDistrict getDistrict;
  final GetVillage getVillage;
  final GetPostal getPostal;

  LocationPermission? _locPermission;
  final _log = AppLogger.instance;
  bool _isRequestingPermission = false;

  final RxList<Province> _province = <Province>[].obs;
  List<Province> get province => _province.value;

  final RxList<Regency> _regency = <Regency>[].obs;
  List<Regency> get regency => _regency.value;

  final RxList<District> _district = <District>[].obs;
  List<District> get district => _district.value;

  final RxList<Village> _village = <Village>[].obs;
  List<Village> get village => _village.value;

  final Rxn<Province> _selProvince = Rxn<Province>();
  Province? get selProvince => _selProvince.value;
  set selProvince(Province? x) => _selProvince.value = x;

  final Rxn<Regency> _selRegency = Rxn<Regency>();
  Regency? get selRegency => _selRegency.value;
  set selRegency(Regency? x) => _selRegency.value = x;

  final Rxn<District> _selDistrict = Rxn<District>();
  District? get selDistrict => _selDistrict.value;
  set selDistrict(District? x) => _selDistrict.value = x;

  final Rxn<Village> _selVillage = Rxn<Village>();
  Village? get selVillage => _selVillage.value;
  set selVillage(Village? x) => _selVillage.value = x;

  TextEditingController postalController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController regencyController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController villageController = TextEditingController();

  final Rx<FetchState> _fetchState = FetchState.idle.obs;
  FetchState get fetchState => _fetchState.value;

  final Rx<FetchState> _provinceFetchState = FetchState.idle.obs;
  FetchState get provinceFetchState => _provinceFetchState.value;

  final Rx<FetchState> _regencyFetchState = FetchState.idle.obs;
  FetchState get regencyFetchState => _regencyFetchState.value;

  final Rx<FetchState> _districtFetchState = FetchState.idle.obs;
  FetchState get districtFetchState => _districtFetchState.value;

  final Rx<FetchState> _villageFetchState = FetchState.idle.obs;
  FetchState get villageFetchState => _villageFetchState.value;

  final Rx<FetchState> _postalFetchState = FetchState.idle.obs;
  FetchState get postalFetchState => _postalFetchState.value;

  @override
  void onInit() {
    super.onInit();
    _log.i('[LOCATION CONTROLLER - onInit]');

    initDropdown();
  }

  initDropdown() async {
    await fetchProvinces();
  }

  Future<void> requestPermisison() async {
    if (_isRequestingPermission) {
      return;
    }
    _isRequestingPermission = true;
    _locPermission = await Geolocator.requestPermission();
    if (_locPermission == LocationPermission.deniedForever) {
      await AppSettings.openAppSettings();
    }
    _log.i(
      '[LOCATION CONTROLLER - requestPermission] _locPermission : $_locPermission',
    );
    _isRequestingPermission = false;
  }

  Future<void> fetchProvinces() async {
    try {
      _provinceFetchState.value = FetchState.loading;
      _province.value = await getProvince();
      _log.i('[LOCATION CONTROLLER - fetchProvince] res : ${_province.value}');
    } catch (e) {
      _log.e('[LOCATION CONTROLLER - fetchProvince] $e');
    } finally {
      _provinceFetchState.value = FetchState.idle;
    }
  }

  Future<void> fetchRegencies(String code) async {
    try {
      _regencyFetchState.value = FetchState.loading;
      _regency.value = await getRegency(code);
      _log.i('[LOCATION CONTROLLER - fetchRegencies] res : ${_regency.value}');
    } catch (e) {
      _log.e('[LOCATION CONTROLLER - fetchRegencies] $e');
    } finally {
      _regencyFetchState.value = FetchState.idle;
    }
  }

  Future<void> fetchDistricts(String code) async {
    try {
      _districtFetchState.value = FetchState.loading;
      _district.value = await getDistrict(code);
      _log.i('[LOCATION CONTROLLER - fetchDistrict] res : ${_district.value}');
    } catch (e) {
      _log.e('[LOCATION CONTROLLER - fetchDistrict] $e');
    } finally {
      _districtFetchState.value = FetchState.idle;
    }
  }

  Future<void> fetchVillages(String code) async {
    try {
      _villageFetchState.value = FetchState.loading;
      _village.value = await getVillage(code);
      _log.i('[LOCATION CONTROLLER - fetchVillage] res : ${_village.value}');
    } catch (e) {
      _log.e('[LOCATION CONTROLLER - fetchVillage] $e');
    } finally {
      _villageFetchState.value = FetchState.idle;
    }
  }

  Future<void> fetchPostal(String code) async {
    try {
      _postalFetchState.value = FetchState.loading;
      List<String> postal = await getPostal(code);
      _log.i('[LOCATION CONTROLLER - fetchPostal] res : $postal');
      if (postal.isNotEmpty) {
        postalController.text = postal.first;
      }
    } catch (e) {
      _log.e('[LOCATION CONTROLLER - fetchPostal] $e');
    } finally {
      _postalFetchState.value = FetchState.idle;
    }
  }

  Future<void> autoFillForm() async {
    try {
      _fetchState.value = FetchState.loading;
      await requestPermisison();
      final LocationSettings androidLoc = AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 100,
        forceLocationManager: true,
      );

      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: GetPlatform.isAndroid ? androidLoc : locationSettings,
      );

      _log.i('[LOCATION CONTROLLER - autoFillForm] position : $position');

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      _log.i('[LOCATION CONTROLLER - autoFillForm] placemarks : $placemarks');

      if (placemarks.isNotEmpty) {
        Placemark pm = placemarks.first;

        final Province? matchedProvince = _bestMatchByName(
          _province,
          pm.administrativeArea,
        );
        if (matchedProvince != null) {
          _selProvince.value = matchedProvince;
          await fetchRegencies(_selProvince.value!.code);

          final Regency? matchedRegency = _bestMatchByName(
            _regency,
            pm.subAdministrativeArea,
          );
          if (matchedRegency != null) {
            _selRegency.value = matchedRegency;
            await fetchDistricts(_selRegency.value!.code);

            final District? matchedDistrict = _bestMatchByName(
              _district,
              pm.locality,
            );
            if (matchedDistrict != null) {
              _selDistrict.value = matchedDistrict;
              await fetchVillages(_selDistrict.value!.code);

              final Village? matchedVillage = _bestMatchByName(
                _village,
                pm.subLocality,
              );
              _selVillage.value = matchedVillage;
            }
          }
        }
        postalController.text = pm.postalCode ?? '';
      }
    } catch (e) {
      _log.e('[LOCATION CONTROLLER - autoFillForm] ERROR : $e');
    } finally {
      _fetchState.value = FetchState.idle;
    }
  }

  clearForm() {
    _selProvince.value = null;
    provinceController.clear();
    regencyController.clear();
    _regency.value = [];
    _selRegency.value = null;
    districtController.clear();
    _district.value = [];
    _selDistrict.value = null;
    villageController.clear();
    _village.value = [];
    _selVillage.value = null;
    postalController.clear();
  }

  onSelectProvince(Province? prov) {
    _selProvince.value = prov;
    _log.i('selProvince : ${_selProvince.value}');
    if (prov != null) {
      regencyController.clear();
      _regency.value = [];
      _selRegency.value = null;
      districtController.clear();
      _district.value = [];
      _selDistrict.value = null;
      villageController.clear();
      _village.value = [];
      _selVillage.value = null;
      postalController.clear();
      fetchRegencies(prov.code);
    }
  }

  onSelectRegency(Regency? reg) {
    _selRegency.value = reg;
    if (reg != null) {
      districtController.clear();
      _district.value = [];
      _selDistrict.value = null;
      villageController.clear();
      _village.value = [];
      _selVillage.value = null;
      postalController.clear();
      fetchDistricts(reg.code);
    }
  }

  onSelectDistrict(District? dis) {
    _selDistrict.value = dis;
    if (dis != null) {
      villageController.clear();
      _village.value = [];
      _selVillage.value = null;
      postalController.clear();
      fetchVillages(dis.code);
    }
  }

  onSelectVillage(Village? vil) {
    _selVillage.value = vil;
    postalController.clear();
    if (vil != null) {
      fetchPostal(vil.name);
    }
  }

  String _normalizeName(String? value) {
    if (value == null) {
      return '';
    }
    String v = value.toLowerCase().trim();
    v = v.replaceAll(RegExp(r'[^\w\s]'), ' ');
    v = v.replaceAll(RegExp(r'\s+'), ' ');
    v = v.replaceAll(RegExp(r'\bdaerah khusus ibukota\b'), 'dki');
    v = v.replaceAll(RegExp(r'\b(kab|kabupaten|kota)\b'), '');
    v = v.replaceAll(RegExp(r'\b(kec|kecamatan)\b'), '');
    v = v.replaceAll(RegExp(r'\b(kel|kelurahan|desa)\b'), '');
    v = v.replaceAll(RegExp(r'\b(kel\.|kec\.)\b'), '');
    return v.trim();
  }

  String _normalizeSignal(String? value) {
    if (value == null) {
      return '';
    }
    String v = value.toLowerCase().trim();
    v = v.replaceAll(RegExp(r'[^\w\s]'), ' ');
    v = v.replaceAll(RegExp(r'\s+'), ' ');
    return v.trim();
  }

  String? _extractAreaType(String value) {
    if (RegExp(r'\bkab\b|\bkabupaten\b').hasMatch(value)) {
      return 'kabupaten';
    }
    if (RegExp(r'\bkota\b').hasMatch(value)) {
      return 'kota';
    }
    return null;
  }

  String? _extractDirection(String value) {
    if (RegExp(r'\bselatan\b').hasMatch(value)) {
      return 'selatan';
    }
    if (RegExp(r'\butara\b').hasMatch(value)) {
      return 'utara';
    }
    if (RegExp(r'\btimur\b').hasMatch(value)) {
      return 'timur';
    }
    if (RegExp(r'\bbarat\b').hasMatch(value)) {
      return 'barat';
    }
    return null;
  }

  T? _bestMatchByName<T extends Object>(List<T> items, String? placemarkName) {
    final String targetSignal = _normalizeSignal(placemarkName);
    if (targetSignal.isEmpty) {
      return null;
    }
    final String target = _normalizeName(targetSignal);
    final String? targetType = _extractAreaType(targetSignal);
    final String? targetDirection = _extractDirection(targetSignal);

    int bestScore = 1 << 30;
    T? bestItem;
    int bestTie = -1;

    for (final item in items) {
      final String rawName = (item as dynamic).name as String? ?? '';
      final String nameSignal = _normalizeSignal(rawName);
      final String name = _normalizeName(nameSignal);
      if (name.isEmpty) {
        continue;
      }
      if (name == target) {
        return item;
      }

      final String? nameType = _extractAreaType(nameSignal);
      final String? nameDirection = _extractDirection(nameSignal);
      int tieScore = 0;
      if (targetType != null && nameType == targetType) {
        tieScore += 2;
      }
      if (targetDirection != null && nameDirection == targetDirection) {
        tieScore += 1;
      }

      if (name.contains(target) || target.contains(name)) {
        if (tieScore > bestTie || (tieScore == bestTie && bestScore > 0)) {
          bestScore = 0;
          bestTie = tieScore;
          bestItem = item;
        }
        continue;
      }

      final int distance = _levenshtein(name, target);
      if (distance < bestScore ||
          (distance == bestScore && tieScore > bestTie)) {
        bestScore = distance;
        bestTie = tieScore;
        bestItem = item;
      }
    }

    if (bestItem == null) {
      return null;
    }

    final int maxLen = target.length;
    if (bestScore > (maxLen <= 6 ? 2 : 3)) {
      return null;
    }

    return bestItem;
  }

  int _levenshtein(String s, String t) {
    if (s == t) {
      return 0;
    }
    if (s.isEmpty) {
      return t.length;
    }
    if (t.isEmpty) {
      return s.length;
    }

    final List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    final List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        final int cost = s[i] == t[j] ? 0 : 1;
        v1[j + 1] = _min3(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost);
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }

    return v1[t.length];
  }

  int _min3(int a, int b, int c) {
    if (a <= b && a <= c) {
      return a;
    }
    if (b <= a && b <= c) {
      return b;
    }
    return c;
  }
}
