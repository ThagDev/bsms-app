import 'package:flutter/material.dart';
import '../../../data/models/ticket_model.dart';
import '../../../data/repositories/ticket_repository.dart';

class TicketViewModel extends ChangeNotifier {
  final TicketRepository _ticketRepository;

  TicketViewModel({TicketRepository? ticketRepository})
      : _ticketRepository = ticketRepository ?? TicketRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TicketModel> _myTickets = [];
  List<TicketModel> get myTickets => _myTickets;

  List<TicketModel> _teamTickets = [];
  List<TicketModel> get teamTickets => _teamTickets;

  String _searchQuery = '';
  String? _selectedStatus;

  Future<void> loadTickets({bool isTeam = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (isTeam) {
        _teamTickets = await _ticketRepository.getTeamTickets();
      } else {
        _myTickets = await _ticketRepository.getMyTickets();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String query, {String? status, bool isTeam = false}) async {
    _searchQuery = query;
    _selectedStatus = status;
    _isLoading = true;
    notifyListeners();

    try {
      final results = await _ticketRepository.searchTickets(query: query, status: status);
      if (isTeam) {
        _teamTickets = results;
      } else {
        _myTickets = results;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateStatus({
    required String ticketId,
    required String newStatus,
    String? note,
  }) async {
    final success = await _ticketRepository.updateTicket(
      ticketId: ticketId,
      status: newStatus,
      note: note,
    );

    if (success) {
      // Cập nhật local list
      _myTickets = _myTickets.map((t) {
        if (t.ticketId == ticketId) {
          return t.copyWith(status: newStatus);
        }
        return t;
      }).toList();
      notifyListeners();
    }
    return success;
  }

  Future<bool> assignTicket({
    required String ticketId,
    required String assignToUserId,
    required String assignToName,
  }) async {
    final success = await _ticketRepository.assignTicket(
      ticketId: ticketId,
      assignToUserId: assignToUserId,
    );

    if (success) {
      _teamTickets = _teamTickets.map((t) {
        if (t.ticketId == ticketId) {
          return t.copyWith(
            status: 'Đã phân công',
            assignedTo: assignToUserId,
            assignedToName: assignToName,
          );
        }
        return t;
      }).toList();
      notifyListeners();
    }
    return success;
  }

  Future<bool> submitRating({
    required String ticketId,
    required int rating,
    String? feedback,
  }) async {
    final success = await _ticketRepository.rateAndFeedback(
      ticketId: ticketId,
      rating: rating,
      feedback: feedback,
    );
    if (success) {
      _myTickets = _myTickets.map((t) {
        if (t.ticketId == ticketId) {
          return t.copyWith(rating: rating, feedbackNote: feedback);
        }
        return t;
      }).toList();
      notifyListeners();
    }
    return success;
  }
}
