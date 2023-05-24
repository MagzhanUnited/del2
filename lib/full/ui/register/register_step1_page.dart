import 'package:flutter/material.dart';
import 'package:themoviedb/full/ui/register/register_step2_driver_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'register_step2_client_page.dart';

class RegisterStep1View extends StatefulWidget {
  RegisterStep1View({Key? key}) : super(key: key);

  @override
  _RegisterStep1ViewState createState() => _RegisterStep1ViewState();
}

class _RegisterStep1ViewState extends State<RegisterStep1View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.register,
          style: TextStyle(
            // color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: MyStatefulWidget(),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool isChecked1 = true;
  bool isChecked2 = false;
  String notCkecked = '';

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal:50),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(),
          SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.vibirite,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 5),
          Text(
            '${AppLocalizations.of(context)!.shag} 1',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 60),
          Text(
            notCkecked,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                shape: CircleBorder(),
                value: isChecked1,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked1 = value!;
                    isChecked2 = false;
                    notCkecked = '';
                    print(isChecked1);
                  });
                },
              ),
              Text(
                AppLocalizations.of(context)!.gruzOtprav,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                shape: CircleBorder(),
                value: isChecked2,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked2 = value!;
                    isChecked1 = false;
                    notCkecked = '';
                    print(isChecked2);
                  });
                },
              ),
              Text(
                AppLocalizations.of(context)!.gruzPerevoz,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),

          SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (!isChecked1 && !isChecked2) {
                  notCkecked = AppLocalizations.of(context)!.vuberiteKategory;
                }
                if (isChecked1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterStep2ClientView()),
                  );
                } else if (isChecked2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterStep2DriverView()),
                  );
                }
              });
            },
            child:  Text(AppLocalizations.of(context)!.prodolzhit),
          ),
        ],
      ),
    );
  }
}
