import 'package:flutter/material.dart';
import '../../../data/models/atm_model.dart';
import '../../../data/models/ticket_model.dart';
import '../../../data/repositories/atm_repository.dart';

class AtmViewModel extends ChangeNotifier {
  final AtmRepository _atmRepository;

  AtmViewModel({AtmRepository? atmRepository})
      : _atmRepository = atmRepository ?? AtmRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<AtmModel> _atms = [];
  List<AtmModel> get atms => _atms;

  List<TicketModel> _atmHistoryTickets = [];
  List<TicketModel> get atmHistoryTickets => _atmHistoryTickets;

  Future<void> loadAtms({String? query}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _atms = await _atmRepository.getAtmList(query: query);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAtmHistory(String atmId) async {
    _atmHistoryTickets = await _atmRepository.getTicketsForAtm(atmId);
    notifyListeners();
  }

  Future<bool> updateAtmInfo(AtmModel atm) async {
    final success = await _atmRepository.updateAtmInfo(atm);
    if (success) {
      _atms = _atms.map((a) => a.atmId == atm.atmId ? atm : a).toList();
      notifyListeners();
    }
    return success;
  }
}
