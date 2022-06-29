import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  ExpensesApp({Key? key}) : super(key: key);

  final ThemeData tema = ThemeData(); // Adicionando Temas

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            button: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

  // Passando as transações recentes para o componente
  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      // filtrando as transações dos últimos 7 dias para uma lista
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    // adiciona uma nova transação
    final newTransaction = Transaction(
      // cria objetos transactions
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      // setando os dados informados
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop(); // Fecha o modal
  }

  // função responsável por deletar uma transação a partir do id da mesma
  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _opentransactionFormModal(BuildContext context) {
    // abre o modal para adição de transações
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
        title: const Text('Despesas Pessoais'), // Titulo Superior
        actions: <Widget>[
          IconButton(
            // botão superior
            icon: const Icon(Icons.add),
            onPressed: () => _opentransactionFormModal(
                context), // chama a abertura do modal para inserir novas transações
          )
        ],
      );

    final availableHeight = MediaQuery.of(context).size.height // tamanho completo da tela
    - appBar.preferredSize.height // tamanho do appBar
    - MediaQuery.of(context).padding.top; // do topo

    return Scaffold(
      appBar: appBar,

      body: SingleChildScrollView(
        // responsável pela scroll view geral da tela
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: availableHeight * 0.3, // tamanho do gráfico
              child: Chart(_recentTransactions),
            ),

            SizedBox(
              height: availableHeight * 0.7, // tamanho da lista
              child: TransactionList(_transactions,_removeTransaction),
            ), // chama a exibição das listas de transações (seus cards)
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        // botão flutuante inferior
        child: const Icon(Icons.add),
        onPressed: () => _opentransactionFormModal(
            context), // chama a abertura do modal para inserir novas transações
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // define a localização do botão flutuante na tela
    );
  }
}
