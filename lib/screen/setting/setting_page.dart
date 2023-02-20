import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:landregistrationbdios/const_data/const_data.dart';
import 'package:landregistrationbdios/screen/land_price/land_price.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_provider/theme_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final text = themeProvider.themeMode == ThemeMode.dark ? 'on' : 'off';

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Dark mode",style: getStyle16(color: Theme.of(context).primaryColor),),
                  Switch.adaptive(
                    value: themeProvider.isDarkMode,
                    onChanged: (value){
                      final provider = Provider.of<ThemeProvider>(context, listen: false);
                      provider.toogleTheme(value);
                    },
                  ),
                ],
              )*/
              ListTile(
                leading: Container(child: Image(image: AssetImage("assets/images/dark.png"),),decoration: BoxDecoration(color: Color(0xFFDEE3EB),borderRadius: BorderRadius.circular(50)),),
                title: Text("Dark mode",style: getStyle16(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                trailing: Switch.adaptive(
                  value: themeProvider.isDarkMode,
                  onChanged: (value){
                    final provider = Provider.of<ThemeProvider>(context, listen: false);
                    provider.toogleTheme(value);
                  },
                  activeColor: Colors.white,
                ),
              ),
              ListTile(
                leading: ElevatedButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LandPrice(),));
                },
                  child: Text('Fees'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
