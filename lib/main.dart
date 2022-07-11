import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> email = [];
  List<String> number = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    callData();
  }

  callData() async {
    final prefs = await SharedPreferences.getInstance();

    email = prefs.getStringList('email')!;
    number = prefs.getStringList('number')!;
    setState(() {});
  }

  int validateEmail(String emailAddress) {
    String patttern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = new RegExp(patttern);
    if (emailAddress.isEmpty || emailAddress.length == 0) {
      return 1;
    } else if (!regExp.hasMatch(emailAddress)) {
      return 2;
    } else {
      return 0;
    }
  }

  int validateNumber(String nmb) {
    if (nmb.isEmpty || nmb.length == 0) {
      return 1;
    } else if (nmb != null && nmb.isNotEmpty && nmb.length <= 9) {
      return 2;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Task'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      int res = validateEmail(value!);
                      if (res == 1) {
                        return "Please fill email address";
                      } else if (res == 2) {
                        return "Please enter valid email address";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: numberController,
                    decoration: InputDecoration(labelText: 'Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      int res = validateNumber(value!);
                      if (res == 1) {
                        return "Please enter Number";
                      } else if (res == 2) {
                        return "Please enter valid Number";
                      } else {
                        return null;
                      }
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      setState(() {
                        if (emailController.text.contains('@') ||
                            numberController.text.length < 9) {
                          email.add(emailController.text);
                          number.add(numberController.text);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Invalid')));
                        }
                        email = email.toSet().toList();
                        number = number.toSet().toList();
                      });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setStringList('email', email);
                      await prefs.setStringList('number', number);
                    },
                    child: Text('ADD DATA')),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: email.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(email[index]),
                    subtitle: Text(number[index]),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
