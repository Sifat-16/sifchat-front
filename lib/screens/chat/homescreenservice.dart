
import 'dart:convert';


import 'package:http/http.dart';
import 'package:sifchat/models/threadmodel.dart';
import 'package:sifchat/models/userprofile.dart';

class UserProfileInfoService{

  Future<List<dynamic>>getAllUser(String token)async{
    try{
      List<UserProfile> userprofiles = [];
      Response rsp = await get(
          Uri.parse("http://192.168.0.104:8000/auth/user/all"),
          headers: <String, String>{
            "Authorization":"Token $token"
          }
      );

      if(rsp.statusCode==200){

        var data = jsonDecode(rsp.body) as Iterable;
        data.forEach((data) {
          UserProfile userProfile = UserProfile();
          userProfile.id = data["user"]["id"].toString();
          userProfile.username = data["user"]["username"];
          userProfile.email = data["user"]["email"];
          userProfile.displayname = data["name"];
          userProfile.bio = data["bio"];
          userProfile.gender = data["gender"];
          userProfile.profileImage = data["image"];
          userprofiles.add(userProfile);
        });
        return [rsp.statusCode,userprofiles];


      }
      return [rsp.statusCode, rsp.body];

    }catch(e){
      return [500];
    }


  }

  Stream<List<Thread>> getAllThreadStream(String token) => Stream.periodic(Duration(seconds: 3)).asyncMap((event) => getAllMyThreadService(token));

  Future<List<Thread>>getAllMyThreadService(String token)async{

    try{
      List<Thread> threads = [];
      Response response = await get(Uri.parse("http://192.168.0.104:8000/auth/mythreads"),

          headers: <String, String>{
            "Authorization":"Token $token"
          }
      );

      print(response.body);
      if(response.statusCode==200){
        var data = jsonDecode(response.body) as Iterable;
        data.forEach((element) {
          Thread thread = Thread();
          thread.id = element['id'];
          thread.updated = element["updated"];
          thread.timestamp = element["timestamp"];
          thread.first = UserProfile()
          ..id = element['first']['id'].toString()
          ..username = element["first"]["user"]["username"]
          ..displayname = element["first"]["name"]
          ..bio = element["first"]["bio"]
          ..email = element["first"]["user"]["email"]
          ..gender = element["first"]["gender"]
          ..profileImage = element["first"]["image"];
          thread.second = UserProfile()
            ..id = element['second']['id'].toString()
            ..username = element["second"]["user"]["username"]
            ..displayname = element["second"]["name"]
            ..bio = element["second"]["bio"]
            ..email = element["second"]["user"]["email"]
            ..gender = element["second"]["gender"]
            ..profileImage = element["second"]["image"];
          try{
            thread.latest_message = element["latest_message"]["message"];

          }catch(e){

          }

          threads.add(thread);


        });
        return threads;

      }
      return [];




    }catch(e){
      return [];
    }


  }

}