// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/full/ui/register/step3_client_fiz_model.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/main_screen/menu_list/profile/profile_model.dart';
import '../../../app/my_app.dart';

import 'package:provider/provider.dart';
import 'package:themoviedb/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

List<String> contents = ["Дороги", "Карты", "Водители", "Машины"];
var Cat = '';
TextEditingController titleText = TextEditingController();
TextEditingController descText = TextEditingController();

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

String? _cat;
String? _title;
String? _desc;

final pm2 = ProfileModel();
List category = [];
bool categoryLoad = true;
bool categoryLoadError = false;

List categoryTems = [];
bool categoryTemsLoad = false;
bool categoryTemsError = false;

class _AddPostPageState extends State<AddPostPage> {
  @override
  void initState() {
    super.initState();
    titleText.text = "";
    descText.text = "";
    Cat = "";

    pm2.setupLocale(context).then((value) {
      initLoad();
    });
  }

  void initLoad() async {
    ForumCategoryLoad(
      token: pm2.token.toString(),
    ).getList().then(
      (value) {
        if (value.toString() == '401') {
          final provider = SessionDataProvider();
          provider.setSessionId(null);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainNavigationRouteNames.changeLang,
              (Route<dynamic> route) => false);
        }

        if (value != 'error') {
          var docs = json.decode(value);

          print('ForumCategoryLoad Sucsess');
          category = docs;
          categoryLoad = false;
          setState(() {});
        } else {
          categoryLoadError = true;
          print('Не удалось получить список ForumCategoryLoad');
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    contents.clear();

    for (var item in category) {
      contents.add(item['catNameRu']);
    }

    final provider = Provider.of<LocaleProvider>(context);

    var fDec = provider.selectedThemeMode == ThemeMode.dark
        ? InputDecoration(
            isDense: true,
            fillColor: Color.fromRGBO(53, 54, 61, 1),
            filled: true,
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
          )
        : InputDecoration(
            isDense: true,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(228, 232, 250, 1))),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newPost),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: provider.selectedThemeMode != ThemeMode.dark
                        ? Colors.white
                        : Color.fromRGBO(27, 28, 34, 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.categoty,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                      DropdownSearch<String>(
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 8),
                          isDense: true,
                          fillColor:
                              provider.selectedThemeMode == ThemeMode.dark
                                  ? Color.fromRGBO(53, 54, 61, 1)
                                  : Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(228, 232, 250, 1))),
                        ),
                        validator: (value) =>
                            value! == AppLocalizations.of(context)!.select
                                ? AppLocalizations.of(context)!.vuberiteKategory
                                : null,
                        onSaved: (value) => _cat = value!,
                        mode: Mode.BOTTOM_SHEET,
                        showSearchBox: true,
                        showSelectedItem: true,
                        items: contents,
                        selectedItem: AppLocalizations.of(context)!.select,
                        onChanged: (newValue) {
                          // setState(() {
                          Cat = newValue!;
                          // });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.tema,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value) => value!.isEmpty
                            ? AppLocalizations.of(context)!.temaNePustaya
                            : null,
                        onSaved: (value) => _title = value!,
                        controller: titleText,
                        textInputAction: TextInputAction.next,
                        decoration: fDec,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          AppLocalizations.of(context)!.coobshenie,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            // color: Colors.black,
                          ),
                        ),
                      ),
                      TextFormField(
                        validator: (value) => value!.isEmpty
                            ? AppLocalizations.of(context)!.opisanieNePustoe
                            : null,
                        onSaved: (value) => _desc = value!,
                        controller: descText,
                        textInputAction: TextInputAction.next,
                        decoration: fDec,
                        minLines: 3,
                        maxLines: 6,
                        keyboardType: TextInputType.multiline,
                      ),
                      _imageFile == null
                          ? SizedBox(height: 10)
                          : Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                AppLocalizations.of(context)!.prikrepitPhoto,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.black,
                                ),
                              ),
                            ),
                      ElevatedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                  width: 2, color: AppColors.primaryColors[0])),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              AppColors.primaryColors[0]),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        onPressed: () => _pickImage(),
                        child: Text(
                          AppLocalizations.of(context)!.prikrepitPhoto,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _imageFile == null
                              ? SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _imageFile = null;
                                        });
                                      },
                                      icon: Icon(Icons.cancel),
                                      label: Text(
                                          AppLocalizations.of(context)!.delete),
                                    ),
                                    Image.file(File(_imageFile!.path)),
                                  ],
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              final FormState? form = _formKey.currentState;
                              if (form!.validate()) {
                                var temp = category
                                    .where(
                                      (element) => element['catNameRu'] == Cat,
                                    )
                                    .toList();
                                if (temp.length > 0) {
                                  String categoryId =
                                      temp[0]['catId'].toString();

                                  ForumUploadPost(
                                    filepath: _imageFile == null
                                        ? null
                                        : _imageFile!.path,
                                    token: pm2.token.toString(),
                                    catId: categoryId,
                                    titleText: titleText.text,
                                    descText: descText.text,
                                  ).get().then(
                                    (value) {
                                      if (value.toString() == '401') {
                                        final provider = SessionDataProvider();
                                        provider.setSessionId(null);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                MainNavigationRouteNames
                                                    .changeLang,
                                                (Route<dynamic> route) =>
                                                    false);
                                      }

                                      if (value != 'error') {
                                        print("ForumUploadPost " + value!);
                                        Navigator.of(context).pop();
                                        initLoad();
                                      } else {
                                        print(
                                            'Не удалось получить список ForumUploadPost');
                                      }
                                    },
                                  );
                                }
                              } else {
                                print('Form is invalid');
                              }
                            },
                            label: Text(
                              AppLocalizations.of(context)!.opublikovatPost,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            icon: Image.asset(
                              "images/11check.png",
                              width: 16,
                              height: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PickedFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<String?> uploadImage(
    filepath,
    token,
    String catId,
    String titleText,
    String descText,
  ) async {
    final String url = 'http://185.116.193.86:8081/postforumtitle';

    Map<String, String> headers = {
      "Content-type": "application/json",
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };
    Map<String, String> data = {
      "catId": catId,
      "title": titleText,
      "description": descText,
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files
        .add(await http.MultipartFile.fromPath('titleImage', filepath));
    request.headers.addAll(headers);
    request.fields.addAll(data);

    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<void> retriveLostData() async {
    // ignore: deprecated_member_use
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      print('Получить ошибку ' + response.exception!.code);
    }
  }

  void _pickImage() async {
    try {
      // ignore: deprecated_member_use
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print("Ошибка выбора изображения " + e.toString());
    }
  }
}
