import 'package:flutter/material.dart';
import '../../../data/models/ticket_model.dart';
import '../../../data/models/atm_model.dart';
import '../../../data/repositories/ticket_repository.dart';
import '../../../data/repositories/atm_repository.dart';
import '../../../data/repositories/master_data_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final TicketRepository _ticketRepository;
  final AtmRepository _atmRepository;
  final MasterDataRepository _masterDataRepository;

  HomeViewModel({
    TicketRepository? ticketRepository,
    AtmRepository? atmRepository,
    MasterDataRepository? masterDataRepository,
  })  : _ticketRepository = ticketRepository ?? TicketRepository(),
        _atmRepository = atmRepository ?? AtmRepository(),
        _masterDataRepository = masterDataRepository ?? MasterDataRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TicketModel> _pendingTickets = [];
  List<TicketModel> get pendingTickets => _pendingTickets;

  int _totalTicketsCount = 0;
  int get totalTicketsCount => _totalTicketsCount;

  int _inProgressTicketsCount = 0;
  int get inProgressTicketsCount => _inProgressTicketsCount;

  int _overdueSlaCount = 0;
  int get overdueSlaCount => _overdueSlaCount;

  int _errorAtmCount = 0;
  int get errorAtmCount => _errorAtmCount;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final tickets = await _ticketRepository.getMyTickets();
      final atms = await _atmRepository.getAtmList();

      _totalTicketsCount = tickets.length;
      _inProgressTicketsCount = tickets.where((t) => t.status.toLowerCase().contains('xử lý')).length;
      _overdueSlaCount = tickets.where((t) => t.isSlaOverdue).length;
      _pendingTickets = tickets.where((t) => !t.status.toLowerCase().contains('hoàn thành')).toList();
      _errorAtmCount = atms.where((a) => a.status.toLowerCase().contains('sự cố') || a.status.toLowerCase().contains('chờ')).length;

      // Đồng bộ master data nền
      _masterDataRepository.syncAll().ignore();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
