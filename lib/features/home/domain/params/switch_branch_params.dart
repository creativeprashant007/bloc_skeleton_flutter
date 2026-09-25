import 'package:dio/dio.dart';

class SwitchBranchParams {
  final int branchId;

  const SwitchBranchParams({required this.branchId});

  FormData toFormData() {
    return FormData.fromMap({'branch_id': branchId});
  }
}
