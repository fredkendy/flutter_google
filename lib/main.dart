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
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<
        MyAppState>(); //O widget MyHomePage rastreia mudanças no estado atual do app usando o método watch.
    var pair = appState.current;

    return Scaffold(
      body: Center(
        //Na column, demos um 'wrap with center'
        child: Column(
          //Isso centraliza os filhos dentro da Column ao longo do eixo principal (vertical)
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text('A random AWESOME idea:'),
          //Era um Text, extraimos o widget e demos este nome, criando outra classe
          BigCard(pair: pair),
          //apenas ocupa espaço e não renderiza nada sozinho.
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ]),
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
        child: Text(pair.asLowerCase,
            style: style, semanticsLabel: "${pair.first} ${pair.second}",),
      ),
    );
  }
}
