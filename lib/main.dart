import 'package:currency_converter/features/currency_converter/presentation/bloc/currency_bloc.dart';
import 'package:currency_converter/features/currency_converter/presentation/pages/currency_converter_page.dart';
import 'package:currency_converter/features/historical_valuation/presentation/bloc/historical_valuation_bloc.dart';
import 'package:currency_converter/features/historical_valuation/presentation/pages/historical_valuation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/di/di_container.dart' as di;
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.setup();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    BlocProvider<CurrencyBloc>(
      create: (context) => di.getIt<CurrencyBloc>(),
      child: CurrencyConverterPage(),
    ),
    BlocProvider<HistoricalValuationBloc>(
      create: (context) => di.getIt<HistoricalValuationBloc>(),
      child: const HistoricalValuationPage(),
    ),
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.white),
              ),
            ),
            child: BottomNavigationBar(
              selectedLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              selectedItemColor: const Color.fromRGBO(38, 90, 165, 1),
              unselectedItemColor: Colors.grey[700],
              backgroundColor: Colors.white,
              currentIndex: _currentIndex,
              onTap: _onTap,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.swap_horiz,
                  ),
                  label: 'Converter',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history,
                  ),
                  label: 'Historical',
                ),
              ],
            ),
          )),
    );
  }
}
