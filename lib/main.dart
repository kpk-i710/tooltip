import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProviderScope(child: Home()),
    );
  }
}


final translateProvider = FutureProvider<List<Two>>((ref) {
  ref.watch(refreshSearch);
  return getTranslate();
});

final refreshSearch = StateProvider((ref) => 0);

Future<List<Two>> getTranslate() async {
  await Future.delayed(const Duration(seconds: 2), () {});

  List<Two> name = [
    for (int i = 0; i < textGlobal.split(" ").length; i++)
      Two(title: textGlobal.split(" ")[i], tip: await getTrans(searched: textGlobal.split(" ")[i]))
  ];

  return name;
}
String textGlobal = "1:1 С именем1 Аллаха2, Милостивого3 Милосердного4.";
Future<String> getTrans({required String searched}) async {
  if (searched.contains("1")) {
    return "1имя [персональное название] (اسم): 2:31, 2:33, 2:114…";
  }
  if (searched.contains("2")) {
    return "2Аллах [нет чего-либо подобного Ему, см. 42:11. Однокоренное слово «Бог» указано в 2:133] (الله): 1:2, 2:7-2:10, 2:15, 2:17, 2:19, 2:20, 2:22, 2:23, 2:26-2:28, 2:55…";
  }
  if (searched.contains("3")) {
    return "3Аллах [нет чего-либо подобного Ему, см. 42:11. Однокоренное слово «Бог» указано в 2:133] (الله): 1:2, 2:7-2:10, 2:15, 2:17, 2:19, 2:20, 2:22, 2:23, 2:26-2:28, 2:55…";
  }
  return "";
}

class Home extends ConsumerStatefulWidget {
  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  String search = "";

  late OverlayEntry overlayEntry;

  @override
  Widget build(BuildContext context) {
    final future = ref.watch(translateProvider);
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(children: [
          SizedBox(height: 200),
          SafeArea(
            child: future.when(
                data: (data) => Wrap(
                    children: List.generate(
                        textGlobal.split(" ").length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: "${data[index].tip}",
                                  child: Text(textGlobal.split(" ")[index])),
                            ))),
                error: (error, stack) => Text("sdf"),
                loading: () => Center(child: CircularProgressIndicator())),
          ),
        ]),
      )),
    );
  }
}

class Two {
  String title;
  String tip;

  Two({this.title = "", this.tip = "подскази нет"});
}
