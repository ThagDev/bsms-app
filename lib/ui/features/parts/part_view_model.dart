import 'package:flutter/material.dart';
import '../../../data/models/part_model.dart';
import '../../../data/repositories/part_repository.dart';

class PartViewModel extends ChangeNotifier {
  final PartRepository _partRepository;

  PartViewModel({PartRepository? partRepository})
      : _partRepository = partRepository ?? PartRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PartModel> _parts = [];
  List<PartModel> get parts => _parts;

  Future<void> loadParts({String? query}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _parts = await _partRepository.getParts(query: query);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> requestPart({
    required String ticketId,
    required String partId,
    required int quantity,
    String? note,
  }) async {
    return await _partRepository.requestPart(
      ticketId: ticketId,
      partId: partId,
      quantity: quantity,
      note: note,
    );
  }
}
