import 'package:flutter/material.dart';

class ZakonDetail extends StatefulWidget {
  final dynamic data;
  const ZakonDetail({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  _ZakonDetailState createState() => _ZakonDetailState();
}

class _ZakonDetailState extends State<ZakonDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Законы и НПА",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            // color: Colors.black87,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              // final pdfFile = await PdfParagraphApi.generate(widget.data);

              // PdfApi.openFile(pdfFile);
            },
            icon: Icon(Icons.download),
          ),
        ],
        // backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            // margin: EdgeInsets.only(top: 16),
            child: ListView.builder(
                itemCount: 1,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return new Container(
                    margin: new EdgeInsets.all(10.0),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          widget.data['title'],
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              // color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        new Padding(
                          padding: new EdgeInsets.symmetric(vertical: 10.0),
                          child: new Divider(
                            height: 1.0,
                            // color: Colors.black,
                          ),
                        ),
                        // new Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     new Icon(
                        //       Icons.access_time,
                        //       color: Colors.grey,
                        //     ),
                        //     new Padding(
                        //       padding:
                        //           new EdgeInsets.symmetric(horizontal: 10.0),
                        //       child: new Text(widget.data['date']),
                        //     )
                        //   ],
                        // ),
                        // new Container(
                        //   width: double.infinity,
                        //   height: 150.0,
                        //   margin: new EdgeInsets.all(10.0),
                        //   child: new Image.network(
                        //     widget.data['img'],
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        new Text(
                          widget.data['desk'],
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  final String imgUrl, title, desc, content, posturl;

  NewsTile({
    required this.imgUrl,
    required this.desc,
    required this.title,
    required this.content,
    required this.posturl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
          margin: EdgeInsets.only(bottom: 24),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imgUrl,
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    desc,
                    maxLines: 2,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class Article {
  String title;
  String author;
  String description;
  String urlToImage;
  DateTime publshedAt;
  String content;
  String articleUrl;

  Article({
    required this.title,
    required this.description,
    required this.author,
    required this.content,
    required this.publshedAt,
    required this.urlToImage,
    required this.articleUrl,
  });
}
