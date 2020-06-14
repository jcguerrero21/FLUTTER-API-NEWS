import 'package:flutter/material.dart';
import 'package:newsprovider/src/models/category_model.dart';
import 'package:newsprovider/src/services/news_service.dart';
import 'package:newsprovider/src/theme/tema.dart';
import 'package:newsprovider/src/widgets/lista_noticias.dart';
import 'package:provider/provider.dart';

class Tab2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context);

    return SafeArea(
      child: Scaffold(
          body: Column(
        children: <Widget>[
          _ListaCategorias(),
          Expanded(
              child:
                  ListaNoticias(newsService.getArticulosCategoriaSeleccionada))
        ],
      )),
    );
  }
}

class _ListaCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<NewsService>(context).categories;

    return Container(
      width: double.infinity,
      height: 80,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final categoryName = categories[index].name;
          return Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                _CategoryButton(category: categories[index]),
                SizedBox(height: 5),
                Text(
                    '${categoryName[0].toUpperCase()}${categoryName.substring(1)}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final Category category;

  const _CategoryButton({this.category});

  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context);

    return GestureDetector(
      onTap: () {
        final newsService = Provider.of<NewsService>(context, listen: false);
        newsService.selectedCategory = category.name;
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Icon(
          category.icon,
          color: (newsService.selectedCategory == this.category.name)
              ? miTema.accentColor
              : Colors.black54,
        ),
      ),
    );
  }
}
