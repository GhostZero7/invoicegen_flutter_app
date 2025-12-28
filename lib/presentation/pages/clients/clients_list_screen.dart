import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicegen_flutter_app/presentation/riverpod/client_provider.dart';
import 'package:invoicegen_flutter_app/presentation/pages/clients/create_client_screen.dart';

class ClientsListScreen extends ConsumerStatefulWidget {
  const ClientsListScreen({super.key});

  @override
  ConsumerState<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends ConsumerState<ClientsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clientProvider.notifier).fetchClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateClientScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(ClientState state) {
    if (state.isLoading && state.clients.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.clients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${state.error}'),
            ElevatedButton(
              onPressed: () {
                ref.read(clientProvider.notifier).fetchClients();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.clients.isEmpty) {
      return const Center(child: Text('No clients found. Create one!'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.clients.length,
      itemBuilder: (context, index) {
        final client = state.clients[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                client.clientName.isNotEmpty
                    ? client.clientName[0].toUpperCase()
                    : '?',
              ),
            ),
            title: Text(
              client.clientName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(client.email ?? 'No email'),
            onTap: () {
              // TODO: Client detail / edit
            },
          ),
        );
      },
    );
  }
}
