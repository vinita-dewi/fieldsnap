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
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

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

  PermissionStatus? _locPermission;
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
    requestPermisison();
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
    _locPermission = await Permission.location.request();
    if (_locPermission == PermissionStatus.permanentlyDenied) {
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
}
