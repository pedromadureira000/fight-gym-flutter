import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fight_gym/main.dart';

showSnackBar (context, String text, String msgType, {scaffoldkey}) {
    Color color = Colors.green;
    IconData snackIcon = Icons.message;
    switch(msgType){
        case "error":
            color = const Color(0xffb44434);
            snackIcon = Icons.error_outline;
        case "success":
            snackIcon = Icons.check_circle;
            color = const Color(0xff089444);
        case "help":
            snackIcon = Icons.message;
            color = const Color(0xff507cb4);
        case "warning":
            snackIcon = Icons.warning;
            color = const Color(0xffc98720);
    }
    List splitedTxt = text.split(': ');
    String title = splitedTxt.length == 2 ? '${tr("Error in the field ")} "${tr(splitedTxt[0])}"' : "";
    text = splitedTxt.length == 2 ? splitedTxt[1] : text;

    Text titleWiget = Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
        )
    );
    Text textWiget = Text(
        tr(text),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        maxLines: 2, 
        overflow: TextOverflow.ellipsis,
    );

    SnackBar snackBar = SnackBar(
        duration: const Duration(seconds: 10),
        content: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Row(
                children: [
                    Icon(snackIcon, color: Colors.white, size: 40),
                    const SizedBox(width: kIsWeb ? 20 : 5),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: title.isEmpty ? [textWiget] : [
                                titleWiget,
                                textWiget
                            ]
                        )
                    ),
                    IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        highlightColor: Colors.white,
                        onPressed: (){
                            var currentContext = MyApp.navKey.currentContext;
                            ScaffoldMessenger.of(currentContext ?? context).removeCurrentSnackBar();
                        },
                    ),
                ]
            ),
        ),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        width: kIsWeb ? 500 : null,
        backgroundColor: Colors.transparent,
    );

    Future.delayed(const Duration(milliseconds: 1), (){
        if (scaffoldkey != null){
            scaffoldkey.currentState!.removeCurrentSnackBar();
            scaffoldkey.currentState!.showSnackBar(snackBar);
        }
        else {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
    });
}
