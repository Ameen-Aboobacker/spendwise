import 'package:flutter/material.dart';
import 'package:moneymanager/presentation/home_page/widgets/balance_tab_decoration.dart';
import 'package:moneymanager/presentation/home_page/widgets/home_decoration.dart';

List accounts = [
  {
    'name': "Bank Account",
    'Balance': 10000,
    'Transactions': [
      {
        'name': 'transaction 11',
        'amount': '1500',
        'type': 'income',
        'category': 'Grocery'
      },
      {
        'name': 'transaction 12',
        'amount': '1100',
        'type': 'income',
        'category': 'book'
      }
    ]
  },
  {
    'name': "Cash Wallet",
    'Balance': 41000,
    'Transactions': [
      {
        'name': 'transaction 21',
        'amount': '1000',
        'type': 'expense',
        'category': 'shopping'
      },
      {
        'name': 'transaction 22',
        'amount': '500',
        'type': 'income',
        'category': 'Grocery'
      },
      {
        'name': 'transaction 23',
        'amount': '500',
        'type': 'income',
        'category': 'Grocery'
      }
    ]
  }
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  num totalBalance = 0;
  List transes = [];
  String selected = 'All';
  void calculateTotalBalance() {
    List sample = [];
    totalBalance = accounts.fold(0, (sum, account) => sum + account['Balance']);
    for (Map<String, dynamic> element in accounts) {
      List a = element['Transactions'] as List;
      for (var element in a) {
        sample.add(element);
      }
    }
    transes = sample;
  }

  void updateTransactions(String? accountName) {
    List sample = [];
    if (accountName == 'All') {
      setState(() {
        selected = accountName!;
        for (Map<String, dynamic> element in accounts) {
          List a = element['Transactions'] as List;
          for (var element in a) {
            sample.add(element);
          }
        }
        transes = sample;
        totalBalance =
            accounts.fold(0, (sum, account) => sum + account['Balance']);
      });
    } else {
      setState(() {
        selected = accountName!;
        var account =
            accounts.firstWhere((account) => account['name'] == accountName);
        transes = account['Transactions'];
        totalBalance = account['Balance'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    calculateTotalBalance();
  }

  @override
  Widget build(BuildContext context) {
    const String user = 'Ameen Grace';

    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPaint(
              painter: HomeDecoration(),
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 47, 15, 0),
                height: size.height * 0.5,
                child: Column(
                  children: [
                    const CustomAppBar(user: user),
                    const SizedBox(height: 30),
                    CustomPaint(
                      painter: BalanceTabDecoration(),
                      child: SizedBox(
                        height: 165,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                showMenu(
                                    context: context,
                                    position: const RelativeRect.fromLTRB(
                                        0, 150, 0, 0),
                                    items: [
                                      PopupMenuItem(
                                        onTap: () {
                                          updateTransactions('All');
                                        },
                                        child: const Text('All'),
                                      ),
                                      ...accounts.map(
                                        (e) => PopupMenuItem(
                                            onTap: () {
                                              updateTransactions(e['name']);
                                            },
                                            value: e['name'],
                                            child: Text(e['name'])),
                                      )
                                    ]);
                              },
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  Text(selected),
                                  const Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Balance',
                                    style: TextStyle(
                                        color: Colors.pink.shade300,
                                        fontSize: 19),
                                  ),
                                  Text(
                                    '₹$totalBalance',
                                    style: const TextStyle(
                                      color: Colors.pink,
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconWidget(icon: Icons.arrow_upward, label: 'Income'),
                        IconWidget(
                            icon: Icons.arrow_downward, label: 'Expense'),
                        IconWidget(icon: Icons.refresh, label: 'Transfer')
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Latest Transactions',
                      style: TextStyle(fontSize: 20),
                    ),
                    Flexible(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        addSemanticIndexes: false,
                        shrinkWrap: true,
                        itemCount: transes.length,
                        itemBuilder: (context, index) {
                          final transcationItem = transes[index];
                          return ListTile(
                            leading: const CircleAvatar(),
                            title: Text(
                              transcationItem['name'],
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                text: 'Income.',
                                style: const TextStyle(color: Colors.green),
                                children: [
                                  TextSpan(
                                      text: 'Grocery',
                                      style: TextStyle(
                                          color: Colors.blue.shade700))
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 0),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class IconWidget extends StatelessWidget {
  const IconWidget({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;

    return Column(
      children: [
        Icon(
          icon,
          color: color,
        ),
        Text(
          label,
          style: TextStyle(color: color),
        )
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.user,
  });

  final String user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $user',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/user_icon.jpg")),
          ),
        ),
      ],
    );
  }
}

class DropdownListitem {
  int value;
  String name;
  DropdownListitem({required this.value, required this.name});
}
