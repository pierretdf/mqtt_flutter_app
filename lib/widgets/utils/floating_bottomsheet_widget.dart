import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_flutter_bloc/blocs/blocs.dart';
import 'package:mqtt_flutter_bloc/models/models.dart';

class FloatingBottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final String secondaryButtonTitle;
  final String mainButtonTitle;
  final Broker function;

  const FloatingBottomSheet({
    Key key,
    @required this.title,
    this.description,
    this.secondaryButtonTitle,
    @required this.mainButtonTitle,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900], //! Theme color
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(color: Colors.grey), //! Theme color
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<BrokerBloc>(context)
                    .add(BrokerDeleted(function));
                Navigator.of(context).pop();
              },
              child: Text(
                mainButtonTitle,
                style: TextStyle(color: Theme.of(context).appBarTheme.color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
