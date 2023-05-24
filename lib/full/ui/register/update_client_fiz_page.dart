import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:themoviedb/providers/provider.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

import 'register_step3_client_fiz_model.dart';

class UpdateClientFizView extends StatefulWidget {
  UpdateClientFizView({
    Key? key,
  }) : super(key: key);

  @override
  _UpdateClientFizViewState createState() => _UpdateClientFizViewState();
}

class _UpdateClientFizViewState extends State<UpdateClientFizView> {
  @override
  Widget build(BuildContext context) {
    final routes =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    var token = routes["token"];
    var clientId = routes["clientId"];
    var firstName = routes["firstName"];
    var lastName = routes["lastName"];
    var email = routes["email"];
    var iinz = routes["iin"];

    final fName = TextEditingController(text: firstName);
    final lName = TextEditingController(text: lastName);
    final pName = TextEditingController();
    final iin = TextEditingController(text: iinz);
    final eMail = TextEditingController(text: email);
    String isEmpWidget = '';

    final textStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Color(0xff212529),
    );
    final textFieldDecorator = const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        isCollapsed: true);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Редактирование данных',
            style: TextStyle(
              // color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Row(),
              // SizedBox(height: 10),

              SizedBox(height: 10),
              CircleAvatar(
                radius: 40,
                backgroundImage: Image.asset(
                          'images/Portrait_Placeholder.png',
                          fit: BoxFit.cover)
                      .image,
              ),
              Text(
                'Выберите фото профиля',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 10,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isEmpWidget,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.red,
                      ),
                    ),
                    const _ErrorMessageWidget(),
                    SizedBox(height: 5),
                    Text(
                      'Фамилия *',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      decoration: textFieldDecorator,
                      controller: lName,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Имя *',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: fName,
                      decoration: textFieldDecorator,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Отчество',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: pName,
                      decoration: textFieldDecorator,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'ИИН *',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: iin,
                      decoration: textFieldDecorator,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Email *',
                      style: textStyle,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: eMail,
                      decoration: textFieldDecorator,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              // _AuthButtonPhoneWidget(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20)),
                    onPressed: () {
                      UpdateClientFiz(
                        img: 'base64img.text',
                        token: token.toString(),
                        clientId: clientId,
                        fName: fName.text,
                        lName: lName.text,
                        pName: '',
                        iin: iin.text,
                        eMail: eMail.text,
                      ).UpdateData().then(
                        (value) {
                          print('Response: $value');

                          if (value.toString() == '401') {
                            final provider = SessionDataProvider();
                            provider.setSessionId(null);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                MainNavigationRouteNames.changeLang,
                                (Route<dynamic> route) => false);
                          }

                          if (value == 'success') {
                            Navigator.of(context).pushReplacementNamed(
                              MainNavigationRouteNames.mainScreen,
                            );
                          }
                        },
                      );
                    },
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        NotifierProvider.watchOnModel<ClientIndiModel>(context)?.errorMessage;

    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(errorMessage,
          style: TextStyle(
            color: Colors.red,
            fontSize: 17,
          )),
    );
  }
}
