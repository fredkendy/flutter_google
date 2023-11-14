import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { //Cada widget define um método build() que é chamado automaticamente sempre que as circunstâncias do widget mudam, para que ele fique sempre atualizado.
    //O estado é criado e fornecido a todo o app usando um ChangeNotifierProvider (confira o código acima em MyApp). Todo widget no app tem acesso ao estado
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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
  var current = WordPair.random(); //Este segundo widget Text usa o appState e acessa o único membro dessa classe, current (que é um WordPair). O WordPair fornece vários getters úteis, como asPascalCase ou asSnakeCase. Aqui, usamos asLowerCase, mas você pode alterar isso agora caso prefira uma das alternativas.

  //O novo método getNext() reatribui o widget current a um novo WordPair aleatório. Ele também chama notifyListeners() (um método de ChangeNotifier) que envia uma notificação a qualquer elemento que esteja observando MyAppState.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); //O widget MyHomePage rastreia mudanças no estado atual do app usando o método watch.

    return Scaffold(
      body: Column(
        children: [
          Text('A random AWESOME idea:'),
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () {
              appState.getNext();
            },
            child: Text('Next'),
          ),
        ]
      ),
    );
  }
}
