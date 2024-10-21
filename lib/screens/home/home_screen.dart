import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ParodiPub/constants.dart';
import 'package:ParodiPub/screens/details/details_screen.dart';
import 'package:ParodiPub/screens/home/components/categorries.dart';
import 'package:ParodiPub/screens/home/components/item_card.dart';
import 'package:get/get.dart';
import 'package:ParodiPub/models/Product.dart';  // Usa Product correttamente
import 'package:ParodiPub/profile/Account.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Usa productList per evitare conflitti
  List<Product> filteredProducts = List.from(productList); // Inizialmente tutti i prodotti

  // Funzione per filtrare i prodotti in base al tag
  void filterProductsByCategory(String selectedTag) {
    setState(() {
      if (selectedTag == 'All') {
        filteredProducts = List.from(productList); // Mostra tutti i prodotti
      } else {
        filteredProducts = productList.where((product) => product.tag == selectedTag.toLowerCase()).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Colore sfondo app
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/search.svg",
              colorFilter: const ColorFilter.mode(kTextColor, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/cart.svg",
              colorFilter: const ColorFilter.mode(kTextColor, BlendMode.srcIn),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/AccountAvatar.svg",
              colorFilter: const ColorFilter.mode(kTextColor, BlendMode.srcIn),
            ),
            onPressed: () {
              Get.toNamed('/account');
            },
          ),
          const SizedBox(width: kDefaultPaddin / 2)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: Text(
              "Our Products",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Categories(onCategorySelected: filterProductsByCategory), // Passa la funzione di filtro
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPaddin,
                  crossAxisSpacing: kDefaultPaddin,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => ItemCard(
                  product: filteredProducts[index],
                  press: () {
                    // Naviga alla schermata dei dettagli
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(product: filteredProducts[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
