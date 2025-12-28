import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_event.dart';
import 'package:invoicegen_flutter_app/presentation/bloc/auth/auth_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Profile')),
      body: ListView(
        children: [
          // Profile Section
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    '${state.user.firstName} ${state.user.lastName}',
                  ),
                  accountEmail: Text(state.user.email),
                  currentAccountPicture: CircleAvatar(
                    child: Text(
                      state.user.firstName.isNotEmpty
                          ? state.user.firstName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Business Profile'),
            subtitle: const Text('Manage your business details'),
            onTap: () {
              // Navigate to business profile edit (future)
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Coming soon')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Products & Services'),
            subtitle: const Text('Manage your catalog'),
            onTap: () {
              // Navigate to products list (future)
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Coming soon')));
            },
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'App Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: false, // TODO: Connect to ThemeProvider
            onChanged: (val) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme switching coming soon')),
              );
            },
            secondary: const Icon(Icons.dark_mode),
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              context.read<AuthBloc>().add(const LogoutEvent());
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
