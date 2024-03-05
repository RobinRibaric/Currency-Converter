import 'package:currency_converter/core/widgets/custom_button.dart';
import 'package:currency_converter/core/widgets/dropdown.dart';
import 'package:currency_converter/features/historical_valuation/presentation/bloc/historical_valuation_bloc.dart';
import 'package:currency_converter/features/historical_valuation/presentation/bloc/historical_valuation_event.dart';
import 'package:currency_converter/features/historical_valuation/presentation/bloc/historical_valuation_state.dart';
import 'package:currency_converter/features/historical_valuation/presentation/widgets/valuation_difference_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import currency codes
import 'package:currency_converter/core/constants/currency_codes.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// Historical Valuation Page
class HistoricalValuationPage extends StatefulWidget {
  const HistoricalValuationPage({super.key});

  @override
  State<HistoricalValuationPage> createState() => _HistoricalValuationPageState();
}

class _HistoricalValuationPageState extends State<HistoricalValuationPage> {
  late HistoricalValuationBloc _historicalValuationBloc;
  late PanelController _pc;

  @override
  void initState() {
    super.initState();
    _historicalValuationBloc = BlocProvider.of<HistoricalValuationBloc>(context);
    _pc = PanelController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(38, 90, 165, 1),
        title: const Text(
          'Historical Valuation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<HistoricalValuationBloc, HistoricalValuationState>(
        listener: (context, state) {
          if (state is HistoricalValuationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is HistoricalValuationLoaded) {
            _animatePanelToPosition(0.0);
          }
        },
        child: SlidingUpPanel(
          controller: _pc,
          defaultPanelState: PanelState.OPEN,
          maxHeight: 450,
          minHeight: 30,
          parallaxEnabled: true,
          parallaxOffset: .5,
          panel: _buildPanel(),
          body: BlocBuilder<HistoricalValuationBloc, HistoricalValuationState>(
            bloc: _historicalValuationBloc,
            builder: (context, state) {
              if (state is HistoricalValuationInitial) {
                return const Center(child: Text('Please select a currency and date range'));
              } else if (state is HistoricalValuationLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Color.fromRGBO(38, 90, 165, 1),
                ));
              } else if (state is HistoricalValuationLoaded) {
                return ValuationDifferenceList(
                    differences: state.historicRates, currency: state.currencyCode, fromDate: state.fromDate, toDate: state.toDate);
              } else if (state is HistoricalValuationError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const Center(child: Text('Please select a currency and date range'));
            },
          ),
        ),
      ),
    );
  }

  _animatePanelToPosition(double position) {
    _pc.animatePanelToPosition(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Dropdown(
            label: 'Currency',
            value: 'SEK - Swedish Krona',
            items: currencyCodes,
            onChanged: _onDropDownChanged,
          ),
          const SizedBox(height: 20),
          BlocBuilder<HistoricalValuationBloc, HistoricalValuationState>(
            bloc: _historicalValuationBloc,
            builder: (context, state) {
              return buildDatePickerField(
                context: context,
                label: 'From',
                dateValue: state.fromDate,
                onDateChanged: _onFromDateChanged,
              );
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<HistoricalValuationBloc, HistoricalValuationState>(
            builder: (context, state) {
              return buildDatePickerField(
                context: context,
                label: 'To',
                dateValue: state.toDate,
                onDateChanged: _onToDateChanged,
              );
            },
          ),
          const SizedBox(height: 20),
          CustomButton(label: 'Confirm', onPressed: _onConfirmPressed),
        ],
      ),
    );
  }

  void _onConfirmPressed() {
    _historicalValuationBloc.add(GetHistoricalValuationData());
  }

  void _onDropDownChanged(String? newValue) {
    if (newValue != null) {
      _historicalValuationBloc.add(UpdateCurrencyEvent(newValue));
    }
  }

  void _onFromDateChanged(DateTime date) {
    _historicalValuationBloc.add(UpdateFromDateEvent(date));
  }

  void _onToDateChanged(DateTime date) {
    _historicalValuationBloc.add(UpdateToDateEvent(date));
  }

  Widget buildDatePickerField({
    required BuildContext context,
    required String label,
    required DateTime dateValue,
    required Function(DateTime) onDateChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: InkWell(
            onTap: () async {
              // Show the date picker dialog
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: dateValue,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != dateValue) {
                onDateChanged(picked);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${dateValue.toLocal()}".split(' ')[0],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 20.0,
                  color: Color.fromRGBO(38, 90, 165, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
