
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sifchat/models/threadmodel.dart';
import 'package:sifchat/screens/auth/login/LoginScreen.dart';
import 'package:sifchat/screens/auth/profile/profilescreen.dart';
import 'package:sifchat/screens/auth/services/authservice.dart';
import 'package:sifchat/screens/chat/chatscreen.dart';
import 'package:sifchat/screens/chat/homescreenservice.dart';
import 'package:sifchat/utility/mycolors.dart';
import 'package:sifchat/utility/screeninfo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/userprofile.dart';

class ChatHome extends StatefulWidget {
  ChatHome({Key? key, required this.userProfile}) : super(key: key);
  UserProfile userProfile;
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {

  AuthService authService = AuthService();
  late Size msize;
  //late WebSocketChannel webSocketChannel;
  UserProfileInfoService userProfileInfoService = UserProfileInfoService();

  List<UserProfile> userProfiles = [];

  bool userprofiledatacollect = false;

  @override
  void initState() {
    
    /*webSocketChannel = WebSocketChannel.connect(Uri.parse("ws://192.168.0.104:8000/ws/sif-socket-server/"));

    webSocketChannel.stream.listen((event) {
      print(event);
    });*/

    // TODO: implement initState
    msize = Size(context: context);
    prefToken().then((value){
      userProfileInfoService.getAllUser(widget.userProfile.token!).then((value) {
        if(value[0]==200){
          setState(() {
            userProfiles = value[1];
          });

        }
        setState(() {
          userprofiledatacollect = true;
        });
      });
    });



    //userProfileInfoService.getAllMyThreadService(widget.userProfile.token!);


    super.initState();
  }






  Future<void> prefToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getInt("loggedin")==null){
      await sharedPreferences.setInt("loggedin", 1);
    }
    if(sharedPreferences.getString("mytoken")==null){
      await sharedPreferences.setString("mytoken", widget.userProfile.token!);
    }else{
      widget.userProfile.token = sharedPreferences.getString("mytoken");
    }
    if(sharedPreferences.getString("userId")==null){
      await sharedPreferences.setString("userId", widget.userProfile.id!);
    }



  }

  @override
  void dispose() {
    // TODO: implement dispose
    //webSocketChannel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBackground,
      drawer: Drawer(
          width: msize.width*.7,
          backgroundColor: myBackground,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_people, color: Colors.white,),
                    Text("SifChat", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      letterSpacing: 1
                    ),)
                  ],
                ),
                SizedBox(
                  height: msize.height*.04,
                ),
                Container(
                  width: msize.width*.6,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.1)
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.userProfile.profileImage==null?AssetImage(widget.userProfile.gender==null?"assets/defaultimage/others.jpg":widget.userProfile.gender=="Male"?"assets/defaultimage/male.jpg":"assets/defaultimage/female.jpg"):NetworkImage(widget.userProfile.profileImage!) as ImageProvider,
                        radius: msize.width*.15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${widget.userProfile.displayname==null?widget.userProfile.username:widget.userProfile.displayname}", style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                          Icon(widget.userProfile.gender==null?Icons.android:widget.userProfile.gender=="Male"?Icons.male:Icons.female, color: Colors.white,)
                        ],
                      ),
                      IconButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfilePageUpdate(userProfile: widget.userProfile, type: 2)));
                      }, icon: Icon(Icons.settings, color: Colors.white,))

                    ],
                  ),
                ),

                SizedBox(
                  height: msize.height*.03,
                ),

                Text("Users", style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),

                userprofiledatacollect?ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: userProfiles.length,
                        itemBuilder: (context, index){

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatScreen(sender: widget.userProfile, receiver: userProfiles[index])));

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blueAccent.withOpacity(0.1)
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(

                                  children: [
                                    CircleAvatar(
                                      backgroundImage: userProfiles[index].profileImage!=null?NetworkImage(userProfiles[index].profileImage!):AssetImage(userProfiles[index].gender==null?"assets/defaultimage/others.jpg":userProfiles[index].gender=="Male"?"assets/defaultimage/male.jpg":"assets/defaultimage/female.jpg") as ImageProvider,
                                      radius: msize.width*.08,
                                    ),
                                    SizedBox(width: 5,),
                                    Text("${userProfiles[index].displayname==null?userProfiles[index].username:userProfiles[index].displayname}", style: TextStyle(
                                      overflow: TextOverflow.ellipsis
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ):AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      WavyAnimatedText("Collecting data..", textStyle: TextStyle(
                        fontStyle: FontStyle.italic
                      ))
                ])


              ],
            ),
          ),
        ),
      ),


      appBar: AppBar(

        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Builder(
                  builder: (ctx){
                    return GestureDetector(
                      onTap: ()=>Scaffold.of(ctx).openDrawer(),
                      child: CircleAvatar(
                        radius: msize.width*.07,
                        backgroundImage:widget.userProfile.profileImage==null?AssetImage(widget.userProfile.gender==null?"assets/defaultimage/others.jpg":widget.userProfile.gender=="Male"?"assets/defaultimage/male.jpg":"assets/defaultimage/female.jpg"):NetworkImage("${widget.userProfile.profileImage!}") as ImageProvider,

                      ),
                    );
                  }
              ),

              SizedBox(width: 8,),

              AnimatedTextKit(
                repeatForever: true,
                isRepeatingAnimation: true,
                  animatedTexts: [
                    ColorizeAnimatedText(
                        "SifChat",
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                        colors: [

                      Colors.white,
                          Colors.blue,
                          Colors.deepPurple
                    ])
                  ]

              ),
            ],
          ),
        ),
        backgroundColor: myBackground,
        actions: [
          IconButton(onPressed: () async{
           var dt = await authService.logoutUserService(widget.userProfile.token!);
            if(dt!=204){

            }else{
              var prefs = await SharedPreferences.getInstance();
              await prefs.remove("mytoken");
              await prefs.remove("userId");
              await prefs.remove("loggedin");
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));

            }
        }, icon: Icon(Icons.logout))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white.withOpacity(0.2)
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white.withOpacity(0.4),),
                    SizedBox(width: 5,),
                    Text("Search", style: TextStyle(
                      color: Colors.white.withOpacity(0.4)
                    ),)
                  ],
                ),
              ),

              SizedBox(height: msize.height*.03,),

              Text("Active users"),
              SizedBox(height: msize.height*.02,),

              Container(

                height: msize.height*.12,
                child: ListView.builder(


                    itemCount: userProfiles.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: msize.width*.07,
                              backgroundImage: userProfiles[index].profileImage==null?AssetImage(userProfiles[index].gender==null?"assets/defaultimage/others.jpg":userProfiles[index].gender=="Male"?"assets/defaultimage/male.jpg":"assets/defaultimage/female.jpg"):NetworkImage("${userProfiles[index].profileImage!}") as ImageProvider,
                            ),
                            Flexible(child: Text("${userProfiles[index].displayname==null?userProfiles[index].username:userProfiles[index].displayname}", style: TextStyle(
                              overflow: TextOverflow.ellipsis
                            ),))
                          ],
                        ),
                      );
                    }
                ),
              ),

              SizedBox(height: msize.height*.03,),
              Text("Messages"),
              SizedBox(height: msize.height*.015,),

              StreamBuilder<List<Thread>>(
                stream: userProfileInfoService.getAllThreadStream(widget.userProfile.token!),
                builder: (context, snapshot) {
                  if(snapshot.hasData){

                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){

                          UserProfile usr1 = snapshot.data![index].first!;
                          UserProfile usr2 = snapshot.data![index].second!;


                          return threadCon(widget.userProfile.username==usr1.username?usr2:usr1, snapshot.data![index].updated!, snapshot.data![index].latest_message);

                        }
                    );
                  }else{
                    return CircularProgressIndicator();
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget threadCon(UserProfile userProfile, String lastupdated, String? lastmessage){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatScreen(sender: widget.userProfile, receiver: userProfile)));
      },
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 0),
          leading: CircleAvatar(
            backgroundImage: userProfile.profileImage==null?AssetImage(userProfile.gender==null?"assets/defaultimage/others.jpg":userProfile.gender=="Male"?"assets/defaultimage/male.jpg":"assets/defaultimage/female.jpg"):NetworkImage("http://192.168.0.104:8000${userProfile.profileImage!}") as ImageProvider,
          ),
          title: Text("${userProfile.displayname==null?userProfile.username:userProfile.displayname}", style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text("$lastmessage",
                  maxLines: 1,
                  style: TextStyle(
                  overflow: TextOverflow.ellipsis,

                ),),
              ),

              Text("${DateFormat.jm().format(DateTime.parse(lastupdated).toLocal())}")
            ],
          ),
        ),
      ),
    );
  }
}
