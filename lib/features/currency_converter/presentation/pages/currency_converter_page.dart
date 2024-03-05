import 'package:currency_converter/core/widgets/custom_button.dart';
import 'package:currency_converter/core/widgets/dropdown.dart';
import 'package:currency_converter/core/widgets/input_field.dart';
import 'package:currency_converter/features/currency_converter/presentation/bloc/currency_bloc.dart';
import 'package:currency_converter/features/currency_converter/presentation/bloc/currency_event.dart';
import 'package:currency_converter/features/currency_converter/presentation/bloc/currency_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import currency codes
import 'package:currency_converter/core/constants/currency_codes.dart';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  late TextEditingController _amountController;
  late CurrencyBloc _currencyBloc;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: "1");
    _currencyBloc = BlocProvider.of<CurrencyBloc>(context);

    // Dispatch the event as soon as the Bloc is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CurrencyBloc>(context).add(FetchInitialCurrencyData());
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(38, 90, 165, 1),
        title: const Text(
          'Currency Converter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildBlocBuilder(),
            const SizedBox(height: 20),
            InputField(label: 'Amount', controller: _amountController),
            const SizedBox(height: 20),
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                return Dropdown(label: 'From', value: state.fromCurrency, items: currencyCodes, onChanged: _onUpdateFromCurrencyChanged);
              },
            ),
            const SizedBox(height: 20),
            _iconButton(),
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                return Dropdown(label: 'To', value: state.toCurrency, items: currencyCodes, onChanged: _onUpdateToCurrencyChanged);
              },
            ),
            const SizedBox(height: 20),
            CustomButton(label: "Convert", onPressed: _onConvertPressed)
          ],
        ),
      ),
    );
  }

  Widget _iconButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(38, 90, 165, 1), width: 2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            icon: const Icon(Icons.swap_vert_sharp, size: 35, color: Color.fromRGBO(38, 90, 165, 1)),
            onPressed: () {
              _currencyBloc.add(SwapCurrenciesEvent());
            },
          ),
        )
      ],
    );
  }

  Widget _buildBlocBuilder() {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        if (state is CurrencyLoading) {
          return state.conversionResult == 0.0
              ? const CircularProgressIndicator()
              : Text('${state.conversionResult} ${state.toCurrencyCode}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
        } else if (state is CurrencyLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${state.amount} ${state.fromCurrency} =\n',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600], height: 0.8),
              ),
              Text(
                ' ${state.conversionResult} ${state.toCurrency}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 0.8),
              )
            ],
          );
        } else if (state is CurrencyError) {
          return Text('Error: ${state.message}');
        }
        return Container(); // Placeholder for initial or undefined state
      },
    );
  }

  void _onConvertPressed() {
    final amount = double.tryParse(_amountController.text);
    if (amount != null) {
      _currencyBloc.add(ConvertCurrency(amount, _currencyBloc.state.fromCurrency, _currencyBloc.state.toCurrency));
    }
  }

  void _onUpdateToCurrencyChanged(String? newValue) {
    if (newValue != null) {
      _currencyBloc.add(UpdateToCurrencyEvent(newValue));
    }
  }

  void _onUpdateFromCurrencyChanged(String? newValue) {
    if (newValue != null) {
      _currencyBloc.add(UpdateFromCurrencyEvent(newValue));
    }
  }
}
