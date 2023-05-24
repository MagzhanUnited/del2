// тут храним сессию которую получаем на экране auth
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const sessionId = 'session_id';
  static const IsComp = 'is_comp';
  static const roleType = 'role_type';
  static const accountId = 'account_id';
  static const phoneNumber = 'phone_number';
  static const carId = 'car_id';
}

class SessionDataProvider {
  static const _secureStorage = FlutterSecureStorage();
  Future<String?> getSessionId() => _secureStorage.read(
        key: _Keys.sessionId,
      );
  Future<String?> getIsComp() => _secureStorage.read(
        key: _Keys.IsComp,
      );
  Future<String?> getRoleType() => _secureStorage.read(
        key: _Keys.roleType,
      );
  Future<String?> getPhoneNumber() => _secureStorage.read(
        key: _Keys.phoneNumber,
      );
  Future<String?> getCarId() => _secureStorage.read(
        key: _Keys.carId
      );

  Future<void> setSessionId(String? value) {
    if (value != null) {
      return _secureStorage.write(key: _Keys.sessionId, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.sessionId);
    }
  }

  Future<void> setIsComp(String? value) {
    if (value != null) {
      return _secureStorage.write(key: _Keys.IsComp, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.IsComp);
    }
  }

  Future<void> setRoleType(String? value) {
    if (value != null) {
      return _secureStorage.write(key: _Keys.roleType, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.roleType);
    }
  }

  Future<void> setPhoneNumber(String? value) {
    if (value != null) {
      return _secureStorage.write(key: _Keys.phoneNumber, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.phoneNumber);
    }
  }

  Future<void> setCarId(String? value) {
    if (value != null) {
      return _secureStorage.write(key: _Keys.carId, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.carId);
    }
  }

  Future<int?> getAccountId() async {
    final id = await _secureStorage.read(key: _Keys.accountId);
    return id != null ? int.tryParse(id) : null;
  }

  Future<void> setAccountId(int? accountId) {
    if (accountId != null) {
      return _secureStorage.write(
          key: _Keys.accountId, value: accountId.toString());
    } else {
      return _secureStorage.delete(key: _Keys.accountId);
    }
  }
}
