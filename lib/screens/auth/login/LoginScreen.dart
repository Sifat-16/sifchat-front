import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sifchat/screens/auth/services/authservice.dart';
import 'package:sifchat/screens/auth/signup/signupscreen.dart';
import 'package:sifchat/screens/chat/homescreen.dart';
import 'package:sifchat/utility/mycolors.dart';
import 'package:sifchat/utility/screeninfo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late Size msize;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  String hintTextusername = "username";
  String hintTextPassword = "password";
  bool hidepass=true;
  bool rememberme = false;
  bool submitpressed = false;
  AuthService authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    msize = Size(context: context);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: myBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Log In", style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                        color: Colors.white.withOpacity(0.3),
                        offset: const Offset(1.5, 1.5),
                        blurRadius: 10),
                  ]
                ),),
                GestureDetector(
                  onTap: ()async{
                    await showDialog(
                      barrierDismissible: true,
                        context: context,
                        builder: (context){
                          return AlertDialog(
                            backgroundColor: myBackground,
                              title: Icon(Icons.warning_amber_outlined, color: Colors.red,),
                            content: Text("Google service is not available now!\nTry manual login"),
                          );
                        }
                    );
                  },
                  child: Container(
                    width: msize.width,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2)
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_circle, color: Colors.white,),
                        Text("Log in with Google", style: TextStyle(
                          fontSize: 15,
                        ),)
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 0.5,
                  color: Colors.white70,
                ),
                TextField(
                  controller: username,
                  decoration: InputDecoration(

                    hintText: hintTextusername,
                    prefixIcon: Icon(Icons.drive_file_rename_outline, color: Colors.white.withOpacity(0.4),),
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6)
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),

                    )
                  ),
                ),
                TextField(
                  controller: password,
                  obscureText: hidepass,
                  decoration: InputDecoration(

                      hintText: hintTextPassword,
                      suffixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              hidepass=!hidepass;
                            });
                          },
                          child: Icon(Icons.remove_red_eye, color: !hidepass?Colors.lightGreenAccent:Colors.red,)),
                      prefixIcon: Icon(Icons.password_outlined, color: Colors.white.withOpacity(0.4),),
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6)
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),

                      )
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      rememberme=!rememberme;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          value: rememberme, onChanged: (k){
                        setState(() {
                          rememberme=k!;
                        });
                      },
                      fillColor: MaterialStateProperty.all(Colors.white),
                        checkColor: Colors.green,

                      ),
                      Text("Remember me", style: TextStyle(
                        letterSpacing: .5
                      ),),


                    ],
                  ),

                ),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.deepPurple.withOpacity(0.2))
                        ),
                        onPressed: ()async{

                          if(username.text.length==0||password.text.length==0){
                            setState(() {
                              hintTextusername = "must put a username";
                              hintTextPassword = "must put password";
                            });
                          }else{

                            BuildContext? dcontext;
                            showDialog(
                                barrierDismissible: false,
                                context: context, builder: (ctx){
                              dcontext = ctx;
                              return AlertDialog(

                                  backgroundColor: myBackground.withOpacity(0.01),
                                  content: Center(
                                    child: AnimatedTextKit(animatedTexts: [
                                      WavyAnimatedText("loging in", textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic
                                      ))
                                    ],
                                      repeatForever: true,

                                    ),
                                  )

                              );
                            });


                            var dt = await authService.loginUserService(username.text, password.text);
                            print(dt[0]);
                            Future.delayed(
                                Duration(seconds: 2),
                                    (){

                                  Navigator.pop(dcontext!);
                                  if(dt[0]!=200){

                                    showDialog(
                                        barrierDismissible: true,
                                        context: context, builder: (context){
                                      List<String> ls = [];
                                      ls.add("Check internet connectivity");
                                      /*Map<dynamic,dynamic>x = dt[1];
                                      x.forEach((key, value) {
                                        ls.add(value.toString());
                                      });*/

                                      return AlertDialog(
                                        backgroundColor: myBackground.withOpacity(0.5),
                                        title: Icon(Icons.warning_amber_outlined, color: Colors.red,),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: ls.map((e) => Text(e)).toList(),
                                        ),
                                      );
                                    });
                                  }else{
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ChatHome(userProfile: dt[1],)));
                                  }


                                }

                            );


                            setState(() {
                              submitpressed=false;

                            });


                          }

                        }, child: Text("Log in")),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.white12,

                ),
                Center(
                  child: Text("Don't have an account?", style: TextStyle(
                    letterSpacing: 0.8,
                  ),),
                ),
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.blueAccent)
                    ),
                    onPressed: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUpPage()));
                  }, child: Text("Sign Up", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),),),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
