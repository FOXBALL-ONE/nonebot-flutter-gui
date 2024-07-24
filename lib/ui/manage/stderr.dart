import 'package:NoneBotGUI/darts/utils.dart';
import 'package:flutter/material.dart';

class StdErr extends StatefulWidget {
  const StdErr({super.key});

  @override
  State<StdErr> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StdErr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${manageBotReadCfgName()} - nbgui_stderr.log",
          style: const TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showConfirmationDialog(context),
            tooltip: "删除报错日志",
            color: Colors.white,
          )
        ],
        backgroundColor: const Color.fromRGBO(238, 109, 109, 1),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: 20000,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(manageBotViewStderr(manageBotReadCfgPath())))),
            ],
          ),
        ),
      ),
    );
  }
}

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('删除'),
        content: const Text('你确定要删除吗？'),
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              '确定',
              style: TextStyle(color: Color.fromRGBO(238, 109, 109, 1)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              deleteStderr(manageBotReadCfgPath());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已删除'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
