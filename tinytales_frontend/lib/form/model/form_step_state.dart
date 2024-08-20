abstract class FormStepState {
  const FormStepState({this.isValid});

  // If null, the step has not been validated on backend
  // If true, the step has successfully been validated on backend
  // If false, the step has failed validation on backend
  final bool? isValid;

  bool canProceed();
}

enum StepActionResult {
  success,
  failure,
}

mixin RetryErrorAction {
  Future<void> retryErrorAction();
}
