abstract class EncryptionState {
  final String strPrivateKey;
  final String strPrivateIV;
  final String strCommonKey;
  final String strCommonIV;
  final String keyString;
  final String ivString;
  final String successMessage;
  final String errorMessage;

  const EncryptionState({
    this.strPrivateKey = "s5%OcwjKB8^JW!jjr6RN1B7T@U8rKeUT",
    this.strPrivateIV = "oxuzK443u%aXSEU8",
    this.strCommonKey = "la_75Eh.8_dJ)fn/QQC@fMk6>?SN/m@0",
    this.strCommonIV = "n<it<8SSSmYngJx>",
    this.keyString = '',
    this.ivString = '',
    this.successMessage = '',
    this.errorMessage = '',
  });

  EncryptionState copyWith({
    String? strPrivateKey,
    String? strPrivateIV,
    String? strCommonKey,
    String? strCommonIV,
    String? keyString,
    String? ivString,
    String? successMessage,
    String? errorMessage,
  }) {
    return EncryptionStateImpl(
      strPrivateKey: strPrivateKey ?? this.strPrivateKey,
      strPrivateIV: strPrivateIV ?? this.strPrivateIV,
      strCommonKey: strCommonKey ?? this.strCommonKey,
      strCommonIV: strCommonIV ?? this.strCommonIV,
      keyString: keyString ?? this.keyString,
      ivString: ivString ?? this.ivString,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


class EncryptionInitial extends EncryptionState {
  const EncryptionInitial() : super();
}


class EncryptionStateImpl extends EncryptionState {
  const EncryptionStateImpl({
    super.strPrivateKey,
    super.strPrivateIV,
    super.strCommonKey,
    super.strCommonIV,
    super.keyString,
    super.ivString,
    super.successMessage,
    super.errorMessage,
  });
}
