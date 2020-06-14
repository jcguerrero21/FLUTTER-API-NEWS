import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsprovider/src/models/category_model.dart';
import 'package:newsprovider/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY = '2f7dbd4a6855463c8a618106562441fc'; //este es mi token que te valdrá para pruebas o te deha´ra de funcionar accede a https://newsapi.org/account y genera uno (creando una cuenta)

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business';

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.footballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'tecnhology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();

    categories.forEach((item) {
      this.categoryArticles[item.name] = new List();
    });
  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada {
    if(this.categoryArticles[this.selectedCategory].length == 0) {
      getArticlesByCategory('business');
    }
    return this.categoryArticles[this.selectedCategory];
  }

  getTopHeadlines() async {
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ca';
    final resp = await http.get(url);

    final newsResponse = newsReponseFromJson(resp.body);

    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {

    if(this.categoryArticles[category].length > 0) {
      return this.categoryArticles[category]; 
    } 
 
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ca&category=$category';
    final resp = await http.get(url);

    final newsResponse = newsReponseFromJson(resp.body);

    this.categoryArticles[category].addAll(newsResponse.articles);

    notifyListeners();
  }
}
