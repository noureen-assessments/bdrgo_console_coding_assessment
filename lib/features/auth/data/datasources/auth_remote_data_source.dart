import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_consumer.dart';
import '../models/me_model.dart';

abstract interface class AuthRemoteDataSource {
  /// Returns the session token.
  Future<String> signIn({required String email, required String password});

  Future<MeModel> fetchMe();

  Future<void> signOut();
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._api);

  final ApiConsumer _api;

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final body = await _api.post(
      ApiEndpoints.signIn,
      data: {'email': email, 'password': password},
    );
    if (body case {'token': final String token} when token.isNotEmpty) {
      return token;
    }
    throw const FormatException('token');
  }

  @override
  Future<MeModel> fetchMe() async {
    final body = await _api.get(ApiEndpoints.me);
    try {
      return MeModel.fromJson(body as Map<String, dynamic>);
    } on TypeError {
      throw const FormatException(ApiEndpoints.me);
    }
  }

  @override
  Future<void> signOut() => _api.post(ApiEndpoints.signOut, data: const {});
}
