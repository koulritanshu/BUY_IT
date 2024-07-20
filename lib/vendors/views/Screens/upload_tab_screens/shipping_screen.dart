import 'package:buyit/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingScreen extends StatefulWidget {
  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? _chargeShipping = false;
  int? _shippingCharges = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            'Charge Shipping',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          value: _chargeShipping,
          onChanged: (value) {
            setState(
              () {
                _chargeShipping = value;
                _productProvider.getFormData(chargeShipping: _chargeShipping);
              },
            );
          },
        ),
        if (_chargeShipping == true)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter shipping charge';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                setState(
                  () {
                    _shippingCharges = int.parse(value);
                    _productProvider.getFormData(
                        shippingCharges: _shippingCharges);
                  },
                );
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Shipping Charge',
              ),
            ),
          ),
      ],
    );
  }
}
