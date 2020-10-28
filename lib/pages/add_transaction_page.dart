import 'package:flutter/material.dart';
import 'package:stocks_app/helpers/db_helper.dart';
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
                          this.type = value;
                        });
                      },
                    ),
                    DbHelper.checkSellPossible(this.stock.symbol)
                        ? RadioListTile<String>(
                            title: const Text('Sell'),
                            value: 'Sell',
                            groupValue: type,
                            onChanged: (value) {
                              setState(() {
                                this.type = value;
                              });
                            },
                          )
                        : Container(),
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
                              if (type == "Sell" &&
                                  this.stock.quantity - numericValue < 0)
                                return 'You have only ${this.stock.quantity} stocks of ${this.stock.symbol}';
                              else
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
                          if (_formKey.currentState.validate()) {
                            if (type == "Buy") {
                              this.stock.boughtAt = this.price;
                              this.stock.quantity =
                                  this.stock.quantity + this.numberOfStocks;
                            } else {
                              this.stock.soldAt = this.price;
                              this.stock.quantity =
                                  this.stock.quantity - this.numberOfStocks;
                            }
                            FocusScope.of(context).unfocus();
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Position added')));
                            DbHelper.addToPortfolio(this.stock, context);
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
