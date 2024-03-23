import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rumkit/useable_widget/color.dart';
import 'package:provider/provider.dart';
import 'package:rumkit/view/menu.dart';
import 'package:rumkit/view_model/map/map_bloc.dart';
import 'package:rumkit/view_model/myloc.dart';
import 'package:rumkit/view_model/perbandingan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LocProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => PersentaseProvider(),
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: white),
          ),
          title: 'Rumah Sakit',
          debugShowCheckedModeBanner: false,
          home: const Menu(),
        ),
      ),
    );
  }
}
