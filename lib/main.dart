import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Cada widget define um método build() que é chamado automaticamente sempre que as circunstâncias do widget mudam, para que ele fique sempre atualizado.
    //O estado é criado e fornecido a todo o app usando um ChangeNotifierProvider (confira o código acima em MyApp). Todo widget no app tem acesso ao estado
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//Em seguida, a classe MyAppState define o estado do app. Este é seu primeiro trabalho no Flutter, então este codelab manterá tudo simples e focado. Existem muitas maneiras eficazes de gerenciar o estado do app no Flutter. Uma das mais fáceis de explicar é ChangeNotifier, a abordagem adotada por este app.
//O MyAppState define os dados necessários para o app funcionar. No momento, ele contém apenas uma variável com o par de palavras aleatórias atual. Você vai adicionar outras opções mais tarde.
//A classe "state" estende o ChangeNotifier, o que significa que ela pode emitir notificações sobre suas próprias mudanças. Por exemplo, se o par de palavras atual mudar, alguns widgets no app precisarão saber disso.

class MyAppState extends ChangeNotifier {
  var current = WordPair
      .random(); //Este segundo widget Text usa o appState e acessa o único membro dessa classe, current (que é um WordPair). O WordPair fornece vários getters úteis, como asPascalCase ou asSnakeCase. Aqui, usamos asLowerCase, mas você pode alterar isso agora caso prefira uma das alternativas.

  //O novo método getNext() reatribui o widget current a um novo WordPair aleatório. Ele também chama notifyListeners() (um método de ChangeNotifier) que envia uma notificação a qualquer elemento que esteja observando MyAppState.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  //Adicionando a lógica de favoritar
  var favorites =
      <WordPair>[]; //inicializada como lista vazia, que só pode conter pares de palavras (generics)

  //remove o par de palavras atual da lista de favoritos (se já estiver lá) ou o adiciona (se ainda não estiver). Em ambos os casos, o código chama notifyListeners(); depois.
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

//Convertemos MyHomePage para um widget com estado
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Essa classe estende State e, portanto, pode gerenciar os próprios valores. Ela pode mudar a si mesma.
class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    //O código declara uma nova variável, page, do tipo Widget.
    Widget page;
    //Em seguida, uma instrução switch atribui uma tela a page, de acordo com o valor atual em selectedIndex.
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        // um widget útil que desenha um retângulo cruzado onde quer que você o coloque, marcando essa parte da interface como incompleta.
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    //O callback builder de LayoutBuilder é chamado sempre que as restrições mudam. Isso acontece nestes casos, por exemplo: O usuário redimensiona a janela do app.
    return LayoutBuilder(
      builder: (context, constraints) {
        //Demos um wrap with builder, em seguida renomeamos para LayoutBuilder e add constraints no builder
        return Scaffold(
          body: Row(
            children: [
              //A SafeArea garante que os filhos não sejam ocultos por um entalhe de hardware ou uma barra de status. Neste app, o widget une a NavigationRail para evitar que os botões de navegação sejam ocultos por uma barra de status móvel, por exemplo.
              SafeArea(
                child: NavigationRail(
                  extended: false,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  //Quando o callback onDestinationSelected é chamado, em vez de simplesmente mostrar o novo valor no console, você o atribui ao selectedIndex dentro de uma chamada setState(). Essa chamada é semelhante ao método notifyListeners() usado antes. Ela garante a atualização da interface.
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              //Os widgets expandidos são extremamente úteis em linhas e colunas. Eles permitem expressar layouts em que alguns filhos ocupam apenas o espaço necessário (NavigationRail, nesse caso) e outros widgets precisam ocupar o máximo possível do espaço restante (Expanded, nesse caso).
              Expanded(
                //Dentro do widget Expanded, há um Container colorido e dentro do contêiner, a GeneratorPage.
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

//todo o conteúdo de MyHomePage é extraído para um novo widget, GeneratorPage. A única parte do antigo widget MyHomePage que não foi extraída é o Scaffold.
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    //o código solicita o tema atual do app com Theme.of(context)
    final theme = Theme.of(context);

    //Ao usar theme.textTheme,, você acessa o tema da fonte do app. Essa classe inclui membros como bodyMedium para texto padrão de tamanho médio, caption para legendas de imagens ou headlineLarge para títulos grandes.
    //O método copyWith() permite mudar muito mais o estilo do texto do que apenas a cor.
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary, fontSize: 20.0);

    return Card(
      //o código define a cor do card para ser a mesma da propriedade colorScheme do tema. O esquema de cores é muito variado, e primary é a cor de mais destaque do app
      color: theme.colorScheme.primary,
      //Neste padding, demos um 'Wrap with Widget -> Card'
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        //Neste Text, demos um Wrap with Padding
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

//Widget detecta o estado atual do app
//Se a lista de favoritos estiver vazia, a mensagem centralizada: No favorites yet (nenhum favorito) vai aparecer. Caso contrário, aparecerá uma lista (rolável).
//A lista começa com um resumo. Por exemplo, You have 5 favorites (você tem 5 favoritos).
//O código é iterado em todos os favoritos e cria um widget ListTile para cada um.
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}
