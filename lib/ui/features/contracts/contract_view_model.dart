import 'package:flutter/material.dart';
import '../../../data/models/contract_model.dart';
import '../../../data/models/atm_model.dart';
import '../../../data/repositories/contract_repository.dart';

class ContractViewModel extends ChangeNotifier {
  final ContractRepository _contractRepository;

  ContractViewModel({ContractRepository? contractRepository})
      : _contractRepository = contractRepository ?? ContractRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ContractModel> _contracts = [];
  List<ContractModel> get contracts => _contracts;

  List<AtmModel> _contractAtms = [];
  List<AtmModel> get contractAtms => _contractAtms;

  Future<void> loadContracts({String? query}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _contracts = await _contractRepository.getContracts(query: query);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadContractAtms(String contractId) async {
    _contractAtms = await _contractRepository.getAtmsByContract(contractId);
    notifyListeners();
  }
}
