import 'package:flutter/material.dart';

// Create a Form widget.
class BuyForm extends StatefulWidget {
  @override
  BuyFormState createState() {
    return BuyFormState();
  }
}

class BuyFormState extends State<BuyForm> {
  int numberOfStocks;
  double price;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[800],
        title: Text("Add a buy transaction"),
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
                          if (_formKey.currentState.validate()) {
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Position added')));
                            Navigator.pop(context);
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
