import 'package:flutter/material.dart';
import 'package:stocks_app/models/stock.dart';

// Create a Form widget.
class Transaction extends StatefulWidget {
  final Stock stock;
  Transaction({Key key, this.stock});
  @override
  _TransactionState createState() {
    return _TransactionState(stock: stock);
  }
}

class _TransactionState extends State<Transaction> {
  Stock stock;
  int numberOfStocks;
  double price;
  String type = "Buy";
  final _formKey = GlobalKey<FormState>();
  _TransactionState({this.stock});

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: Text("Add a position for ${this.stock.symbol}"),
      ),
      body: Builder(
        builder: (context) => Center(
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 24),
                  children: <Widget>[
                    RadioListTile<String>(
                      title: const Text('Buy'),
                      value: 'Buy',
                      groupValue: type,
                      onChanged: (value) {
                        setState(() {
                          type = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Sell'),
                      value: 'Sell',
                      groupValue: type,
                      onChanged: (value) {
                        setState(() {
                          type = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                      ),
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
                      decoration: InputDecoration(labelText: 'At price'),
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
