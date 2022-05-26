import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sifchat/screens/auth/login/LoginScreen.dart';
import 'package:sifchat/screens/auth/profile/profilescreen.dart';
import 'package:sifchat/screens/auth/services/authservice.dart';
import 'package:sifchat/utility/screeninfo.dart';

import '../../../utility/mycolors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  late Size msize;
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController rpassword = TextEditingController();

  String text_username="";
  String text_email="";
  String text_password="";
  String text_rpassword="";

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
    email.dispose();
    password.dispose();
    rpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        //resizeToAvoidBottomInset: true,
        backgroundColor: myBackground,
        body: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: msize.width,
              minHeight: msize.height
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                        Text("Sign Up", style: TextStyle(
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
                                content: Text("Google service is not available now!\nTry manual sign up"),
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
                            Text("Sign up with Google", style: TextStyle(
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
                      onChanged: (txt)=>setState(()=>text_username),

                      decoration: InputDecoration(
                          errorText: submitpressed&&_errorTextUsername!=null?_errorTextUsername:_errorTextUsername,
                          hintText: "username",
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
                      controller: email,
                      onChanged: (t)=>setState(()=>text_email),
                      decoration: InputDecoration(
                          errorText: submitpressed&&_errorTextEmail!=null?_errorTextEmail:_errorTextEmail,

                          hintText: "email",
                          prefixIcon: Icon(Icons.email_outlined, color: Colors.white.withOpacity(0.4),),
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
                      onChanged: (t)=>setState(()=>text_password),
                      decoration: InputDecoration(
                          errorText: submitpressed&&_errorTextPassword!=null?_errorTextPassword:_errorTextPassword,
                          hintText: "password",
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
                    TextField(
                      controller: rpassword,
                      obscureText: hidepass,
                      onChanged: (t)=>setState(() => text_rpassword),
                      decoration: InputDecoration(
                        errorText: submitpressed&&_errorTextRPassword!=null?_errorTextRPassword:_errorTextRPassword,
                          hintText: "confirm password",
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

                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.deepPurple.withOpacity(0.2))
                            ),
                            onPressed: () async{

                              setState(() {
                                submitpressed=true;
                              });

                              if(_errorTextUsername==null&&_errorTextEmail==null&&_errorTextPassword==null&&_errorTextRPassword==null){

                                BuildContext? dcontext;
                                showDialog(
                                    barrierDismissible: false,
                                    context: context, builder: (ctx){
                                  dcontext = ctx;
                                    return AlertDialog(

                                      backgroundColor: myBackground.withOpacity(0.01),
                                      content: Center(
                                        child: AnimatedTextKit(animatedTexts: [
                                          WavyAnimatedText("creating", textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic
                                          ))
                                        ],
                                        repeatForever: true,

                                        ),
                                      )

                                    );
                                  });


                                var dt = await authService.signupservice(text_username, text_email, text_password);

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
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfilePageUpdate(userProfile: dt[1],type: 1,)));
                                        }


                                    }

                                );


                                setState(() {
                                  submitpressed=false;

                                });


                              }

                              /*setState(() {
                                submitpressed=false;
                              });*/


                            }, child: Text("Create")),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.white12,

                    ),
                    Center(
                      child: Text("Already have an account?", style: TextStyle(
                        letterSpacing: 0.8,
                      ),),
                    ),
                    Center(
                      child: TextButton(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.blueAccent)
                        ),
                        onPressed: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));

                        }, child: Text("Sign in", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                      ),),),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  String? get _errorTextUsername{
    text_username = username.value.text;

    if(submitpressed){
      if(text_username.length==0){
        return "User must have username";
      }
    }

    if(text_username.contains(" ")){
      return "Can't have space";
    }

    return null;
  }
  String? get _errorTextEmail{
    text_email = email.value.text;

    if(submitpressed){
      if(text_email.length==0){
        return "User must have email";
      }
    }

    if(text_email.length==0){
      return null;
    }

    if(text_email.contains(" ")||!text_email.contains("@")||!text_email.contains(".com")){
      return "Invalid email address";
    }

    return null;
  }

  String? get _errorTextPassword{
    text_password = password.value.text;

    if(submitpressed){
      if(text_password.length==0){
        return "Password can't be empty";
      }
    }

    if(text_password.length==0){
      return null;
    }

    if(text_password.length<4){
      return "Too short";
    }

    return null;
  }

  String? get _errorTextRPassword{
    text_rpassword = rpassword.value.text;

    if(submitpressed){
      if(text_rpassword.length==0){
        return "Must confirm the password";
      }
    }

    if(text_rpassword.length==0){
      return null;
    }

    if(text_password.length>0&&text_rpassword!=text_password){
      return "Password didn't match";
    }

    return null;
  }



}
