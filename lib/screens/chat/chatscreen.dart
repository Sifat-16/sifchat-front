import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sifchat/models/userprofile.dart';
import 'package:sifchat/utility/mycolors.dart';
import 'package:sifchat/utility/screeninfo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/message.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, required this.sender, required this.receiver}) : super(key: key);
  UserProfile sender;
  UserProfile receiver;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late WebSocketChannel webSocketChannel;
  TextEditingController msg = TextEditingController();
  List<Message> messages = [];
  ScrollController scrollController = ScrollController();
  late Size msize;
  bool hastexttosend = false;


  @override
  void initState() {

    msize = Size(context: context);
    // TODO: implement initState
    webSocketChannel = WebSocketChannel.connect(Uri.parse("ws://192.168.0.104:8000/ws/sif-socket-server/${widget.sender.username}/${widget.receiver.username}/"));
    webSocketChannel.stream.listen((event) {


      var data = jsonDecode(event);
      if(data["type"]=="allmessage"){
        var msgs = data["messages"] as Iterable;
        msgs.forEach((element) {
          Message message = Message()
          ..message = element["message"]
          ..sender = element["sender"]["user"]["username"];
          setState(() {
            messages.insert(0, message);
          });

        });
      }else if(data["type"]=="newmessage"){
        Message message = Message()
            ..message = data["msg"]["messages"]["message"]
            ..sender = data["msg"]["messages"]["sender"]["user"]["username"];
        setState(() {
          messages.insert(0, message);
        });
      }

      //scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.easeIn);


    });




    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    webSocketChannel.sink.close();
    scrollController.dispose();
    msg.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: myBackground,
        appBar: AppBar(



          backgroundColor: myBackground,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){

                  },

                  child: CircleAvatar(
                    backgroundImage:widget.receiver.profileImage==null?AssetImage(widget.receiver.gender==null?"assets/defaultimage/others.jpg":widget.receiver.gender=="Male"?"assets/defaultimage/male.jpg":"assets/defaultimage/female.jpg"):NetworkImage("http://192.168.0.104:8000${widget.receiver.profileImage!}") as ImageProvider,

                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: ListTile(
                    title: Text("${widget.receiver.displayname==null?widget.receiver.username:widget.receiver.displayname}", style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    subtitle: Text("Active.....", style: TextStyle(

                      color: Colors.white.withOpacity(0.4)
                    ),),
                  ),
                ),

              ],
            ),
          ),
        ),
        body: Column(

          children: [

            Expanded(
                  child: ListView.builder(
                    reverse: true,

                    controller: scrollController,
                    itemCount: messages.length,
                      itemBuilder: (context, index){
                      print(messages[index].sender);
                      print(widget.sender.username);
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: FractionallySizedBox(
                  alignment: messages[index].sender==widget.sender.username?Alignment.centerRight:Alignment.centerLeft,
                  widthFactor: messages[index].sender==widget.sender.username?0.65:0.8,
                  child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5),



                        child: Align(
                          alignment: messages[index].sender==widget.sender.username?Alignment.centerRight:Alignment.centerLeft,
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: messages[index].sender==widget.sender.username?Colors.blueAccent.withOpacity(0.1):Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20), topLeft: messages[index].sender!=widget.sender.username?Radius.zero:Radius.circular(20), topRight: messages[index].sender==widget.sender.username?Radius.zero:Radius.circular(20))

                                ),
                                child: Text("${messages[index].message}"))
                        )
                    ),

                ),
              );
            }),
                ),



            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (s){
                  if(s.length>0){
                    setState(() {
                      hastexttosend=true;
                    });
                  }else{
                    setState(() {
                      hastexttosend=false;
                    });

                  }
                },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: msg,
                  decoration: InputDecoration(
                    fillColor: Colors.white.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Visibility(
                      visible: !hastexttosend,
                      child: Icon(Icons.camera, color: Colors.white,),
                    ),
                    suffixIcon: hastexttosend?IconButton(onPressed: (){
                      webSocketChannel.sink.add(msg.text);
                      setState(() {
                        hastexttosend=false;
                        msg.clear();
                      });

                    }, icon: Icon(Icons.send, color: Colors.lightBlue,)):Icon(Icons.mic, color: Colors.blue,),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25)
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(25)
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25)
                    )
                  ),

                ),
            ),

          ],
        ),
      ),
    );
  }
}
