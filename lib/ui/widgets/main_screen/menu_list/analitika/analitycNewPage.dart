import 'package:flutter/material.dart';
import 'package:themoviedb/ui/widgets/main_screen/bottom_screens/menu_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'AppStat.dart';
import 'Dozvol.dart';
import 'LPI.dart';
import 'Ports.dart';
import 'Transit.dart';
import 'vseVidy.dart';

class AnaliticList extends StatefulWidget {
  const AnaliticList({Key? key}) : super(key: key);

  @override
  State<AnaliticList> createState() => _AnaliticListState();
}

class _AnaliticListState extends State<AnaliticList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: MenuView()),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.analityc)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              VseVidyTransporta(),
              Lpi(),
              Port(),
              Dozvol(),
              Tranzit(),
              AppStat(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox VseVidyTransporta() {
    return SizedBox(
      height: 80.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => VseVidy()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Icons.auto_graph_sharp, size: 18.0),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  AppLocalizations.of(context)!.vseVidy,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox Lpi() {
    return SizedBox(
      height: 70.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LpiPage()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Icons.circle_outlined, size: 18.0),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  AppLocalizations.of(context)!.lpi,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox Port() {
    return SizedBox(
      height: 80.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Ports()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Icons.anchor, size: 18.0),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  AppLocalizations.of(context)!.porty,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox Dozvol() {
    return SizedBox(
      height: 80.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dozvols()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Icons.document_scanner_outlined, size: 18.0),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  AppLocalizations.of(context)!.dozvol,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox Tranzit() {
    return SizedBox(
      height: 80.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Transits()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Icons.transform, size: 18.0),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  AppLocalizations.of(context)!.tranzit,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox AppStat() {
    return SizedBox(
      height: 80.0,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AppStats()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Icons.lens_blur_outlined, size: 18.0),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  AppLocalizations.of(context)!.statPrilozh,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.chevron_right, size: 25.0),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
