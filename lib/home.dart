import 'package:flutter/material.dart';
import 'package:flutter_application_store/models/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'page_detail.dart';
import 'package:flutter_application_store/models/product.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyHomeState();
  }
}

class _MyHomeState extends State<MyHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  Map<String?, List<Product>?> filtreParCat = {};
  // int? indexCat;

  Future<List<Product>?> recupData() async {
    String url =
        "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json";
    http.Response response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        listProduct = List<Product>.from(data!.map((x) => Product.fromJson(x)));

        listProduct?.sort((a, b) {
          final aFav = a.isUrgent as bool;
          final bFav = b.isUrgent as bool;

          if (aFav == bFav) {
            final aDate = DateTime.parse(a.creationDate!) as DateTime;
            final bDate = DateTime.parse(b.creationDate!) as DateTime;

            return -aDate.compareTo(bDate);
          } else {
            return aFav ? -1 : 1;
          }
        });
        // var maDate = DateTime.parse(listProduct?[0].creationDate ?? 'rien') !=
        //     DateTime.parse(listProduct?[1].creationDate ?? 'rien');
        // print(maDate);

        return listProduct;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<Category>?> recupCat() async {
    String url =
        "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json";
    http.Response response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        dataCat = json.decode(response.body);
        listCategory =
            List<Category>.from(dataCat!.map((x) => Category.fromJson(x)));
        return listCategory;
      }
    } on Exception catch (e) {
      print(e);
    }
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
              // print(dataC?[y]['name']);
              productByCat[dataP?[i]['category_id']] = dataC?[y]['name'];
            }
          }
        }
        return productByCat;

        // productItem = List<ProductItem>.from(
        //     dataCombine!.map((x) => ProductItem.fromJson(x)));
        // print(productItem);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    recupData().then((value) {
      setState(() {
        displayProduct = value;
      });
    });
    recupCat().then((value) {
      setState(() {
        displayCategory = value;
      });
    });
    correspondance().then((value) {
      setState(() {
        productByCat = value!;
      });
    });
  }

  Text monTexte(String data,
      {Color couleur = Colors.black,
      double taille = 20.0,
      String styleText = "",
      FontWeight largeur = FontWeight.normal,
      TextAlign alignement = TextAlign.center}) {
    return Text(
      textAlign: alignement,
      data,
      style: TextStyle(
        color: couleur,
        fontSize: taille,
        fontFamily: styleText,
        fontWeight: largeur,
      ),
    );
  }

  String truncate(String? text, {length: 8, omission: ''}) {
    text = text?.split('T').join(' ');
    String? tableau1 = text?.split(' ')[0];
    tableau1 = tableau1?.split('-').reversed.toList().join('-');
    String? tableau2 = text?.split(' ')[1];
    text = tableau1! + "  ${tableau2!}";

    if (length >= text.length) {
      return text;
    }
    return text.replaceRange(length, text.length, omission);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ListView.builder(
          itemCount: displayCategory?.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print('${displayCategory?[index].name} tapé');
                Navigator.pop(context);
                categorieProduitFilter(displayCategory?[index].id);
              },
              child: ListTile(
                  trailing: const Icon(
                    Icons.arrow_forward,
                    color: Color.fromARGB(255, 155, 0, 52),
                  ),
                  leading: const Icon(
                    Icons.category,
                    color: Color.fromARGB(255, 155, 0, 52),
                  ),
                  title: monTexte("${displayCategory?[index].name}",
                      taille: 18.5,
                      largeur: FontWeight.bold,
                      alignement: TextAlign.start)),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        height: 50.0,
        color: Color.fromARGB(255, 155, 0, 52),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            monTexte("produits : ${displayProduct?.length}",
                couleur: Colors.white),
            Switch(
              value: boolSwitch,
              onChanged: (bool b) {
                setState(() {
                  boolSwitch = b;
                  urgentProduitFilter(b);
                });
              },
              activeTrackColor: Colors.white,
              inactiveThumbColor: Color.fromARGB(255, 196, 33, 87),
              thumbColor: MaterialStateProperty.all<Color?>(
                  Color.fromARGB(255, 199, 195, 195)),
            )
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          )
        ],
        backgroundColor: Color.fromARGB(255, 155, 0, 52),
        centerTitle: true,
        title: monTexte("Flutter Store",
            taille: 26.0,
            largeur: FontWeight.w600,
            styleText: "DancingScript",
            couleur: Colors.white),
        leading: const Icon(
          Icons.shopping_bag,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              controller: tf,
              onChanged: searchProduct,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_outlined),
                hintText: "Chercher un produit",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: const Color(0xFF000000))),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: recupData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: displayProduct?.length,
                        itemBuilder: (contextListe, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(contextListe,
                                  MaterialPageRoute(builder: (contextListe) {
                                return PageDetail(
                                  key: const Key("PageDetail"),
                                  product: displayProduct![index],
                                );
                              }));
                            },
                            child: Card(
                              color: Color.fromARGB(255, 255, 255, 255),
                              elevation: 5.0,
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.10,
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: monTexte(
                                        truncate(
                                            displayProduct?[index].creationDate,
                                            length: 20),
                                        couleur:
                                            Color.fromARGB(255, 131, 130, 130),
                                        alignement: TextAlign.start),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              height: 100.0,
                                              width: 100.0,
                                              child: Card(
                                                  //print(data);
                                                  child: Image.network(
                                                "${displayProduct?[index].imagesUrl?.thumb}",
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Image.asset(
                                                      "assets/images/no_Image.jpg");
                                                },
                                              )),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 5.0),
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 5.0,
                                                ),
                                                child: TextButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<Color?>(
                                                              Color.fromARGB(
                                                                  255,
                                                                  155,
                                                                  0,
                                                                  52)),
                                                      foregroundColor:
                                                          MaterialStateProperty
                                                              .all<Color?>(
                                                                  Colors.white),
                                                      elevation:
                                                          MaterialStateProperty
                                                              .all<double?>(5.0)),
                                                  onPressed: () {},
                                                  child: monTexte(
                                                      "${productByCat[displayProduct?[index].categoryId]}",
                                                      taille: 17.0,
                                                      couleur: Colors.white),
                                                )),
                                          )
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.85,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                height: 95.0,
                                                child: monTexte(
                                                    "${displayProduct?[index].title}"),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 10.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  monTexte(
                                                      "${displayProduct?[index].price} €",
                                                      couleur: Color.fromARGB(
                                                          255, 67, 100, 228)),
                                                  (displayProduct?[index]
                                                              .isUrgent) ==
                                                          true
                                                      ? Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: Icon(
                                                              Icons
                                                                  .notifications,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      155,
                                                                      0,
                                                                      52),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 155, 0, 52),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  void searchProduct(String query) {
    List<Product> resultats = [];
    if (query.isNotEmpty) {
      if (boolSwitch) {
        resultats = listProduct!
            .where((element) =>
                element.title!.toLowerCase().contains(query.toLowerCase()) &&
                element.isUrgent!)
            .toList();
      } else {
        resultats = listProduct!
            .where((element) =>
                element.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } else {
      resultats = listProduct!;
    }

    setState(() {
      displayProduct = resultats;
    });
  }

  void urgentProduitFilter(bool v) {
    List<Product> isUrgentProduct = [];
    if (v) {
      isUrgentProduct =
          listProduct!.where((element) => element.isUrgent!).toList();
    } else {
      isUrgentProduct = listProduct!;
    }

    setState(() {
      displayProduct = isUrgentProduct;
    });
  }

  void categorieProduitFilter(int? idDansCategory) {
    // for (int i = 0; i < listCategory!.length; i++) {
    //   var nomCategory = listCategory?[i].name;
    //   for (int y = 0; y < listProduct!.length; y++) {
    //     if (listCategory?[i].id == listProduct?[y].categoryId) {
    //       print("${listCategory?[i].name}");
    //       listefiltrer = listProduct
    //           ?.where((element) => element.categoryId == i + 1)
    //           .toList();
    //       filtreParCat[listCategory?[i].name] = listefiltrer;
    //     }
    //   }
    //   // print(nomCategory.runtimeType);
    //   // print(listefiltrer.runtimeType);
    //   // print(filtreParCat.runtimeType);
    //   // filtreParCat[nomCategory] = listefiltrer;
    // }
    setState(() {
      displayProduct = listProduct
          ?.where((element) => element.categoryId == idDansCategory)
          .toList();
    });
  }
}
