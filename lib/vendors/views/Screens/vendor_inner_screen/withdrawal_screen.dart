import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

class WithdrawalScreen extends StatefulWidget {
  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  late String amount;
  late String name;
  late String mobile;
  late String bankName;
  late String bankAccountName;
  late String bankAccountNumber;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.pink.shade600,
        title: Text(
          'WITHDRAW',
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter amount';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    amount = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter mobile';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    mobile = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Mobile',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter bank name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    bankName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Bank Name (eg. Axis Bank)',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter bank account name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    bankAccountName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Bank Account Name',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter account number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    bankAccountNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Bank Account Number',
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.pink,
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          EasyLoading.show(
                            status: 'Entering request',
                          );
                          await _firebaseFirestore
                              .collection('withdrawals')
                              .doc(Uuid().v4())
                              .set(
                            {
                              'withdrawalAmount': amount,
                              'withdrawalName': name,
                              'withdrawalMobile': mobile,
                              'withdrawalBankName': bankName,
                              'withdrawalBankAccountName': bankAccountName,
                              'withdrawalBankAccountNumber': bankAccountNumber,
                              'withdrawalVendorId':
                                  FirebaseAuth.instance.currentUser!.uid,
                            },
                          ).whenComplete(
                            () {
                              EasyLoading.dismiss();
                              _formKey.currentState!.reset();
                            },
                          );
                        }
                      },
                      child: Text(
                        'WITHDRAW MONEY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                          letterSpacing: 6,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
