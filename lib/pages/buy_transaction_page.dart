import 'package:flutter/material.dart';
import 'package:stocks_app/models/stock.dart';

// Create a Form widget.
class BuyForm extends StatefulWidget {
  final Stock stock;
  BuyForm({Key key, this.stock});
  @override
  _BuyFormState createState() {
    return _BuyFormState(stock: stock);
  }
}

class _BuyFormState extends State<BuyForm> {
  Stock stock;
  int numberOfStocks;
  double price;
  final _formKey = GlobalKey<FormState>();
  _BuyFormState({this.stock});

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: Text("Add a buy transaction for ${this.stock.symbol}"),
      ),
      body: Builder(
        builder: (context) => Center(
            child: Form(
                key: _formKey,
                child: new ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 24),
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'Number of stocks bought'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Value must not be empty';
                        } else {
                          int numericValue = int.tryParse(value);
                          if (numericValue == null) {
                            return 'Value must be a number';
                          } else {
                            if (numericValue < 0) {
                              return 'Number must be positive';
                            } else {
                              this.numberOfStocks = numericValue;
                            }
                          }
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Price', hintText: 'Price at the time'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Value must not be empty';
                        } else {
                          double numericValue = double.tryParse(value);
                          if (numericValue == null) {
                            return 'Value must be a number';
                          } else {
                            if (numericValue < 0) {
                              return 'Number must be positive';
                            } else {
                              this.price = numericValue;
                            }
                          }
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: RaisedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Position added')));
                            new Future.delayed(
                                const Duration(milliseconds: 1500), () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Text('Confirm'),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}
