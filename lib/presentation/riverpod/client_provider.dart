import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:invoicegen_flutter_app/data/models/client.dart';
import 'package:invoicegen_flutter_app/data/repositories/client_repository.dart';

// State class
class ClientState {
  final List<Client> clients;
  final bool isLoading;
  final String? error;

  ClientState({this.clients = const [], this.isLoading = false, this.error});

  ClientState copyWith({
    List<Client>? clients,
    bool? isLoading,
    String? error,
  }) {
    return ClientState(
      clients: clients ?? this.clients,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier class
class ClientNotifier extends StateNotifier<ClientState> {
  final ClientRepository _repository;

  ClientNotifier(this._repository) : super(ClientState());

  Future<void> fetchClients({String? businessId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final clients = await _repository.getClients(businessId: businessId);
      state = state.copyWith(clients: clients, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> createClient(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newClient = await _repository.createClient(data);
      state = state.copyWith(
        clients: [...state.clients, newClient],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateClient(String clientId, Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedClient = await _repository.updateClient(clientId, data);
      final updatedClients = state.clients.map((client) {
        return client.id == clientId ? updatedClient : client;
      }).toList();
      
      state = state.copyWith(
        clients: updatedClients,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteClient(String clientId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.deleteClient(clientId);
      final updatedClients = state.clients.where((client) => client.id != clientId).toList();
      
      state = state.copyWith(
        clients: updatedClients,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<List<dynamic>> fetchInvoicesForClient(String clientId) async {
    try {
      return await _repository.getInvoicesForClient(clientId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return [];
    }
  }
}

// Provider
final clientProvider = StateNotifierProvider<ClientNotifier, ClientState>((
  ref,
) {
  return ClientNotifier(GetIt.I<ClientRepository>());
});
