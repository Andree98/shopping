import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/injection.dart';
import 'package:shopping/presentation/home/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection();
  runApp(const Shopping());
}

class Shopping extends StatelessWidget {
  const Shopping({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => getIt<HomeCubit>()..loadShoppingLists(),
        child: const HomeScreen(),
      ),
    );
  }
}
