import 'dart:io';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

import 'package:image_picker/image_picker.dart';
import 'package:sifchat/models/userprofile.dart';
import 'package:sifchat/screens/auth/services/authservice.dart';
import 'package:sifchat/screens/chat/homescreen.dart';
import 'package:sifchat/utility/mycolors.dart';
import 'package:sifchat/utility/screeninfo.dart';

class ProfilePageUpdate extends StatefulWidget {
  ProfilePageUpdate({Key? key, required this.userProfile, required this.type}) : super(key: key);
  UserProfile userProfile;
  int type;
  @override
  _ProfilePageUpdateState createState() => _ProfilePageUpdateState();
}

class _ProfilePageUpdateState extends State<ProfilePageUpdate> {

  late Size msize;
  final List<String> gender = [
    "Other",
    "Female",
    "Male"
  ];
  late String gender_selected;
  bool editname=false;
  TextEditingController namecontroller = TextEditingController();

  final _picker = ImagePicker();
  XFile? image;
  File? cimage;
  String displayname = "";
  bool submitpressed = false;

  AuthService authService = AuthService();

  _pickImage(ImageSource imageSource)async{
      image = await _picker.pickImage(source: imageSource);
      var lst = image!.path.split("/");
      var cp = "cp";
      lst.removeAt(0);
      lst[lst.length-1] = cp+lst[lst.length-1];
      var tp = "";
      lst.forEach((element) {
        tp+="/";
        tp+=element;
      });
      print(tp);


      File? result = await FlutterImageCompress.compressAndGetFile(image!.path, tp, quality: 50);

      setState(() {
        cimage=result;
      });



      print(cimage!.path);
  }



  @override
  void initState() {
    // TODO: implement initState
    print(widget.userProfile.profileImage);
    displayname = widget.userProfile.username!;
    gender_selected = gender[0];
    msize = Size(context: context);
    namecontroller.text = widget.userProfile.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: myBackground,
          elevation: 0,
          leading: SizedBox.shrink(),
        ),
        backgroundColor: myBackground,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                      children: [
                        Center(
                          child: ShaderMask(

                            shaderCallback: (Rect bounds) {
                              return LinearGradient(colors: [
                                Color(0xfff5f7fa), Color(0xffc3cfe2)
                              ]).createShader(bounds);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: msize.width*.27,
                              child: CircleAvatar(
                                  radius: msize.width*.25,
                                  backgroundImage: cimage==null?widget.userProfile.profileImage!=null?NetworkImage(widget.userProfile.profileImage!):AssetImage(gender_selected==gender[0]?"assets/defaultimage/others.jpg":gender_selected==gender[1]?"assets/defaultimage/female.jpg":"assets/defaultimage/male.jpg") as ImageProvider:FileImage(cimage!),
                              ),
                            ),
                          ),
                        ),
                        Center(

                            child: GestureDetector(
                              onTap: (){
                                _pickImage(ImageSource.gallery);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: msize.width*.27,
                                child: Icon(Icons.camera_alt_outlined, size: msize.width*.15, color: Colors.white,),
                              ),
                            ),

                        ),
                        Visibility(
                          visible: cimage!=null?true:false,
                          child: Positioned(
                              right: msize.width*.2,
                              child: IconButton(onPressed: (){
                                setState(() {
                                  cimage=null;
                                });


                              }, icon: Icon(Icons.delete, color: Colors.white,))
                          ),
                        )

                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !editname?Text("$displayname", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          letterSpacing: 1,
                          overflow: TextOverflow.ellipsis
                        ),):Expanded(
                          child: TextField(

                            onChanged: (t){
                              if(t.length==0){
                                setState(() {
                                  displayname=widget.userProfile.username!;
                                  print(displayname);
                                });
                              }else{
                                setState(() {
                                  displayname=t;
                                  print(displayname);
                                });
                              }

                            },
        controller: namecontroller,
        decoration: InputDecoration(

            hintText: "display name",
            prefixIcon: Icon(Icons.edit, color: Colors.white.withOpacity(0.4),),
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
                        ),
                        IconButton(onPressed: (){
                            setState(() {
                              editname=!editname;
                            });
                        }, icon: Icon(!editname?Icons.edit:Icons.done, color: Colors.white,))
                      ],
                    ),
                  SizedBox(height: 25,),

                  IconButton(onPressed:() async{
                    await showDialog(context: context, builder: (context){
                      return AlertDialog(
                        backgroundColor: myBackground,
                        title: Center(child: Text("Gender")),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: gender.map((e) => RadioListTile(
                              title: Text(e),
                              value: e,
                              selected: gender_selected==e,
                              groupValue: gender_selected,

                              onChanged: (value){
                                setState(() {
                                  gender_selected=value.toString();
                                });
                                Navigator.of(context).pop();
                              }
                          )).toList(),
                        ),
                      );
                    });
                        },
                    icon: Icon(gender_selected==gender[0]?Icons.android:gender_selected==gender[1]?Icons.female:Icons.male, color: Colors.white,)),

                  SizedBox(
                    height: 50,
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal.withOpacity(0.3))
                      ),
                      onPressed: () async{


                          setState(() {
                            submitpressed=true;
                          });



                            BuildContext? dcontext;
                            showDialog(
                                barrierDismissible: false,
                                context: context, builder: (ctx){
                              dcontext = ctx;
                              return AlertDialog(

                                  backgroundColor: myBackground.withOpacity(0.01),
                                  content: Center(
                                    child: AnimatedTextKit(animatedTexts: [
                                      WavyAnimatedText("Saving data", textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic
                                      ))
                                    ],
                                      repeatForever: true,

                                    ),
                                  )

                              );
                            });

                       var dt = await authService.updateProfileService(widget.userProfile.id!, displayname, "", cimage, gender_selected, widget.userProfile);


                            Future.delayed(
                                Duration(seconds: 5),
                                    (){

                                  Navigator.pop(dcontext!);
                                  if(dt[0]!=200){

                                    showDialog(
                                        barrierDismissible: true,
                                        context: context, builder: (context){
                                      List<String> ls = [];
                                      ls.add("Check internet connectivity");


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




                      },
                      child: Text("Save"),
                    ),
                  )


                ],
              ),
            ),
          ),
        ),

      ),

    );
  }

}
