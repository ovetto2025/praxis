import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:praxis/features/authentication/logic/bloc/auth_bloc.dart';
import 'package:praxis/features/authentication/logic/bloc/auth_event.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home (Test Luoghi)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                context.read<AuthBloc>().add(AuthSignOutRequested()),
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          final u = snapshot.data ?? user;
          final name = (u?.displayName?.trim().isNotEmpty ?? false)
              ? u!.displayName!
              : (u?.email ?? '');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Benvenuto, $name',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),

                // 🌍 TEST BUTTONS PER I 4 LUOGHI
                ElevatedButton(
                  onPressed: () => context.push('/place/piazza_ottinetti'),
                  child: const Text('Vai a Piazza Ottinetti'),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () => context.push('/place/piazza_santa_marta'),
                  child: const Text('Vai a Piazza Santa Marta'),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () => context.push('/place/teatro_giacosa'),
                  child: const Text('Vai al Teatro Giacosa'),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () => context.push('/place/museo_garda'),
                  child: const Text('Vai al Museo Garda'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
