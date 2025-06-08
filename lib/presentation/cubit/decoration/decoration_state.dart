class DecorationState {}

class DecorationLoading extends DecorationState {}

class DecorationInfo extends DecorationState {
  final String petString;

  DecorationInfo(this.petString);
}

class DecorationError extends DecorationState {}