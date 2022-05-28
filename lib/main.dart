import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/injection.dart';
import 'package:shopping/presentation/screens/create_list_screen.dart';
import 'package:shopping/presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureInjection();
  runApp(Shopping());
}

class Shopping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (_) => BlocProvider(
              create: (_) => getIt<HomeCubit>(),
              child: const HomeScreen(),
            ),
        CreateListScreen.id: (_) => BlocProvider(
              create: (_) => getIt<CreateListBloc>(),
              child: const CreateListScreen(),
            )
      },
    );
  }
}
