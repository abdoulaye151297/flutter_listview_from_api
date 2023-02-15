import 'package:flutter/material.dart';
import 'package:flutter_application_store/models/product.dart';
import 'package:flutter_application_store/models/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class PageDetail extends StatefulWidget {
  Product product;
  PageDetail({super.key, required this.product});

  @override
  State<PageDetail> createState() => _PageDetailState();
}

class _PageDetailState extends State<PageDetail> {
  List? data;
  List? dataP;
  List? dataC;
  List? dataCat;
  List<Product>? listProduct;
  List<Product>? displayProduct;
  List<Category>? listCategory;
  List<Category>? displayCategory;
  bool boolSwitch = false;
  TextEditingController tf = TextEditingController();
  Map<int, String> productByCat = {};

  Text monTexte(String data,
      {Color couleur: Colors.black,
      double taille: 20.0,
      String styleText: "",
      FontWeight largeur: FontWeight.normal}) {
    return Text(
      textAlign: TextAlign.center,
      data,
      style: TextStyle(
        color: couleur,
        fontSize: taille,
        fontFamily: styleText,
        fontWeight: largeur,
      ),
    );
  }

  String truncate(String? text, {length: 15, omission: ''}) {
    text = text?.split('T').join(' ');
    String? tableau1 = text?.split(' ')[0];
    tableau1 = tableau1?.split('-').reversed.toList().join('-');
    String? tableau2 = text?.split(' ')[1];
    text = tableau1! + " à ${tableau2!}";

    if (length >= text.length) {
      return text;
    }
    return text.replaceRange(length, text.length, omission);
  }

  Future<Map<int, String>?> correspondance() async {
    String url_P =
        "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json";
    String url_C =
        "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json";
    http.Response response_P = await http.get(Uri.parse(url_P));
    http.Response response_C = await http.get(Uri.parse(url_C));
    //List<http.Response> allRes = [response_P, response_C];
    try {
      if (response_P.statusCode == 200 && response_C.statusCode == 200) {
        dataP = json.decode(response_P.body);
        dataC = json.decode(response_C.body);

        for (int i = 0; i < dataP!.length; i++) {
          for (int y = 0; y < dataC!.length; y++) {
            if (dataP?[i]['category_id'] == dataC?[y]['id']) {
              productByCat[dataP?[i]['category_id']] = dataC?[y]['name'];
            }
          }
        }
        return productByCat;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    correspondance().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 155, 0, 52),
        centerTitle: true,
        title: monTexte("Flutter Store",
            taille: 26.0,
            largeur: FontWeight.w600,
            couleur: Colors.white,
            styleText: "DancingScript"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 18.0,
              ),
              Container(
                padding: const EdgeInsets.all(2.5),
                child: monTexte("${widget.product.title}",
                    largeur: FontWeight.bold, taille: 25.0),
              ),
              Container(
                height: 18.0,
              ),
              Container(
                  color: Color.fromARGB(255, 229, 229, 229),
                  height: 280.0,
                  width: MediaQuery.of(context).size.width / 1.05,
                  //print(data);
                  child: Image.network(
                    "${widget.product.imagesUrl?.small}",
                    fit: BoxFit.contain,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset("assets/images/no_Image.jpg");
                    },
                  )),
              Container(
                height: 18.0,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  child: monTexte("${widget.product.description}")),
              // Container(
              //   height: 18.0,
              // ),
              Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                child: monTexte(
                    "Ajouté le ${truncate(widget.product.creationDate, length: 21)}",
                    largeur: FontWeight.w500),
              ),
              // Container(
              //   height: 18.0,
              // ),
              Container(
                margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color.fromARGB(255, 243, 230, 230),
                ),
                // color: Colors.grey[200],
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              elevation:
                                  MaterialStateProperty.all<double?>(2.0),
                              backgroundColor:
                                  MaterialStateProperty.all<Color?>(
                                      Colors.grey[100]),
                              side: MaterialStateProperty.all<BorderSide?>(
                                  BorderSide(
                                color: Color.fromARGB(255, 155, 0, 52),
                              ))),
                          onPressed: (() {}),
                          child: monTexte(
                              "${productByCat[widget.product.categoryId] ?? "Chargement..."}",
                              couleur: Color.fromARGB(255, 155, 0, 52))),
                      TextButton(
                        onPressed: (() {}),
                        child: monTexte(
                          "${widget.product.price} €",
                          largeur: FontWeight.w500,
                          couleur: Color.fromARGB(255, 155, 0, 52),
                        ),
                      ),
                      TextButton(
                        onPressed: (() {}),
                        child: (widget.product.isUrgent) == true
                            ? Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 155, 0, 52),
                                    borderRadius: BorderRadius.circular(15)),
                              )
                            : Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 173, 173, 173),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                      )
                    ]),
              ),
              Container(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
