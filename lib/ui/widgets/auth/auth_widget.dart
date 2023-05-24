import 'package:flutter/material.dart';
import 'package:themoviedb/providers/provider.dart';

import 'auth_model.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login to your account'),
        ),
        body: ListView(
          children: [
            _HeaderWidget(),
          ],
        ));
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final textStyle = const TextStyle(fontSize: 16, color: Colors.black);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          _FormWidget(),
          // SizedBox(
          //   height: 25,
          // ),
          // Text(
          //   'Чтобы пользоваться правкой и возможностями рейтинга TMDB, '
          //   'а также получить персональные рекомендации, необходимо войти '
          //   'в свою учётную запись. Если у вас нет учётной записи, '
          //   'её регистрация является бесплатной и простой. Нажмите здесь, '
          //   'чтобы начать.',
          //   style: textStyle,
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          // TextButton(
          //     style: AppButtonStyle.linkButton,
          //     onPressed: () {},
          //     child: Text('Register')),
          // SizedBox(
          //   height: 25,
          // ),
          // Text(
          //   'Если Вы зарегистрировались, но не получили письмо для '
          //   'подтверждения, нажмите здесь, чтобы отправить письмо повторно.',
          //   style: textStyle,
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          // TextButton(
          //     style: AppButtonStyle.linkButton,
          //     onPressed: () {},
          //     child: Text('Verify email')),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.readFromModel<AuthModel>(context);
    final textStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xff212529),
    );
    final textFieldDecorator = const InputDecoration(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        isCollapsed: true);
    //Объявляем переменную почему так не понял
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _ErrorMessageWidget(),
        // Text(
        //   'Username',
        //   style: textStyle,
        // ),
        // SizedBox(height: 5),
        // TextField(
        //   decoration: textFieldDecorator,
        //   controller: model?.loginTextController,
        // ),
        // SizedBox(height: 5),
        // Text(
        //   'Password',
        //   style: textStyle,
        // ),
        // SizedBox(height: 5),
        // TextField(
        //   controller: model?.passwordTextController,
        //   obscureText: true,
        //   decoration: textFieldDecorator,
        // ),
        // SizedBox(height: 25),
        // Row(
        //   children: [
        //     const _AuthButtonWidget(),
        //     SizedBox(
        //       width: 30,
        //     ),
        //     TextButton(
        //       onPressed: () {},
        //       child: Text('Reset password'),
        //       style: AppButtonStyle.linkButton,
        //     ),
        //   ],
        // ),
        SizedBox(height: 25),
        Text(
          'Phone number',
          style: textStyle,
        ),
        SizedBox(height: 5),
        TextField(
          decoration: textFieldDecorator,
          controller: model?.phoneNumber,
        ),
        SizedBox(height: 5),
        _AuthButtonPhoneWidget(),
        SizedBox(height: 25),
        Text(
          'code',
          style: textStyle,
        ),
        SizedBox(height: 5),
        TextField(
          decoration: textFieldDecorator,
          controller: model?.code,
        ),
        SizedBox(height: 5),
        _AuthButtonCodeWidget(),
      ],
    );
  }
}

class _AuthButtonPhoneWidget extends StatelessWidget {
  const _AuthButtonPhoneWidget({Key? key}) : super(key: key);

  void pressff(BuildContext context) {
    final model = NotifierProvider.watchOnModel<AuthModel>(context);
    if (model?.canStartAuth == true) {
      model?.authPhone(context);
      print('can start auth 174');
    } else {
      print('cant start auth 176');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF01b4e4);
    final model = NotifierProvider.watchOnModel<AuthModel>(context);
    final child = model?.isAuthProgress == true
        ? const SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 11),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            height: 19,
            width: 41,
          )
        : const Text('Send code');
    return ElevatedButton(
      onPressed: () => pressff(context),
      child: child,
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.zero),
          backgroundColor: MaterialStateProperty.all(color),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 15, vertical: 8))),
    );
  }
}

class _AuthButtonCodeWidget extends StatelessWidget {
  const _AuthButtonCodeWidget({Key? key}) : super(key: key);

  void pressff(BuildContext context) {
    final model = NotifierProvider.watchOnModel<AuthModel>(context);
    if (model?.canStartAuth == true) {
      model?.authCode(context);
      print('can start auth 220');
    } else {
      print('cant start auth 222');
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF01b4e4);
    final model = NotifierProvider.watchOnModel<AuthModel>(context);
    final child = model?.isAuthProgress == true
        ? const SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 11),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            height: 19,
            width: 41,
          )
        : const Text('login');
    return ElevatedButton(
      onPressed: () => pressff(context),
      child: child,
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.zero),
          backgroundColor: MaterialStateProperty.all(color),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 15, vertical: 8))),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        NotifierProvider.watchOnModel<AuthModel>(context)?.errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child:
          Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 17)),
    );
  }
}
