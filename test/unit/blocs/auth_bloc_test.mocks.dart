import 'dart:async' as _i4;

import 'package:gestanea/features/auth/data/models/auth_repo.dart' as _i3;
import 'package:gestanea/features/auth/data/models/user_entity.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

class _FakeUserEntity_0 extends _i1.SmartFake implements _i2.UserEntity {
  _FakeUserEntity_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [AuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRepository extends _i1.Mock implements _i3.AuthRepository {
  MockAuthRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.UserEntity> signUp({
    required String? name,
    required String? email,
    required String? password,
    String? phone,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#signUp, [], {
              #name: name,
              #email: email,
              #password: password,
              #phone: phone,
            }),
            returnValue: _i4.Future<_i2.UserEntity>.value(
              _FakeUserEntity_0(
                this,
                Invocation.method(#signUp, [], {
                  #name: name,
                  #email: email,
                  #password: password,
                  #phone: phone,
                }),
              ),
            ),
          )
          as _i4.Future<_i2.UserEntity>);

  @override
  _i4.Future<_i2.UserEntity> login({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#login, [], {#email: email, #password: password}),
            returnValue: _i4.Future<_i2.UserEntity>.value(
              _FakeUserEntity_0(
                this,
                Invocation.method(#login, [], {
                  #email: email,
                  #password: password,
                }),
              ),
            ),
          )
          as _i4.Future<_i2.UserEntity>);

  @override
  _i4.Future<_i2.UserEntity?> getCurrentUser() =>
      (super.noSuchMethod(
            Invocation.method(#getCurrentUser, []),
            returnValue: _i4.Future<_i2.UserEntity?>.value(),
          )
          as _i4.Future<_i2.UserEntity?>);

  @override
  _i4.Future<_i2.UserEntity> updateUser(_i2.UserEntity? user) =>
      (super.noSuchMethod(
            Invocation.method(#updateUser, [user]),
            returnValue: _i4.Future<_i2.UserEntity>.value(
              _FakeUserEntity_0(this, Invocation.method(#updateUser, [user])),
            ),
          )
          as _i4.Future<_i2.UserEntity>);

  @override
  _i4.Future<void> logout() =>
      (super.noSuchMethod(
            Invocation.method(#logout, []),
            returnValue: _i4.Future<void>.value(),
            returnValueForMissingStub: _i4.Future<void>.value(),
          )
          as _i4.Future<void>);
}
