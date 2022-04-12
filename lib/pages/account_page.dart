import 'package:e_learnig_clone/datas/account_menu_json.dart';
import 'package:e_learnig_clone/datas/user_profile.dart';
import 'package:e_learnig_clone/theme/colors.dart';
import 'package:e_learnig_clone/theme/padding.dart';
import 'package:e_learnig_clone/widgets/custom_button_box.dart';
import 'package:e_learnig_clone/widgets/custom_heading.dart';
import 'package:e_learnig_clone/widgets/custom_place_holder.dart';
import 'package:e_learnig_clone/widgets/custom_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  

  @override
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
      ),
      body:getBody(),
    );
  }

  Widget getSignIn() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(appPadding),
      child: Column(
        children: [
          SizedBox(height: spacer - 1.0),

          //header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomHeading(
                title: 'Account',
                subTitle: 'Student',
                color: secondary,
              ),
            ],
          ),
          SizedBox(height: spacer),

          Column(
            children: List.generate(1, (index) {
              List data = AccountMenuJson[2]['categories'];
              return Padding(
                padding: const EdgeInsets.only(bottom: spacer),
                child: Column(
                  children: [
                    CustomTitle(
                      title: AccountMenuJson[2]['title'],
                      extend: false,
                    ),
                    SizedBox(height: smallSpacer),
                    Column(
                      children: List.generate(data.length, (j) {
                        return CunstomPlaceHolder(
                          title: data[j]['title'],
                          isSwitch: data[j]['isSwitch'],
                        );
                      }),
                    )
                  ],
                ),
              );
            }),
          ),
          GestureDetector(
            onTap: () async {
           
            },
            child: CustomButtonBox(title: 'Sign In'),
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(appPadding),
      child: Column(
        children: [
          SizedBox(height: spacer - 1.0),

          //header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomHeading(
                title: 'Cuenta',
                subTitle: 'Participante',
                color: secondary,
              ),
              Text(
                'Deseas postear tus propios retos?',
                style: TextStyle(color: primary, fontSize: 15.0),
              ),
            ],
          ),
          SizedBox(height: spacer),

          //profile
          Container(
            height: size.width * .3,
            width: size.width * .3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                UserProfile['image'].toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: smallSpacer),
          Text(
            UserProfile['full_name'].toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: secondary,
            ),
          ),
          SizedBox(height: miniSpacer),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Editar Perfil',
              style: TextStyle(
                fontSize: 15,
                color: primary,
              ),
            ),
          ),
          SizedBox(height: spacer),

          Column(
            children: List.generate(
              AccountMenuJson.length,
              (index) {
                List data = AccountMenuJson[index]['categories'];
                return Padding(
                  padding: const EdgeInsets.only(bottom: spacer),
                  child: Column(
                    children: [
                      CustomTitle(
                        title: AccountMenuJson[index]['title'],
                        extend: false,
                      ),
                      SizedBox(height: smallSpacer),
                      Column(
                        children: List.generate(
                          data.length,
                          (j) {
                            return CunstomPlaceHolder(
                              title: data[j]['title'],
                              isSwitch: data[j]['isSwitch'],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              showCupertinoModalPopup(
                  context: context, builder: (context) => getPopup());
            },
            child: CustomButtonBox(title: 'Sign Out'),
          ),
          SizedBox(height: smallSpacer),
          Container(
            alignment: Alignment.center,
            child: Text(
              'V0.0.1',
              style:
                  TextStyle(fontSize: 12.0, color: secondary.withOpacity(.5)),
            ),
          ),
          SizedBox(height: spacer),
        ],
      ),
    );
  }

  Widget getPopup() {
    return CupertinoActionSheet(
      title: const Text('¿Estas seguro de que quieres salir?'),
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancelar',
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          onPressed: () {
            print("Loged out");
          },
          child: const Text(
            'Sign Out',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}