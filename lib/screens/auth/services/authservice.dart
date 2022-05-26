import 'dart:convert';

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:sifchat/models/userprofile.dart';

class AuthService{

  Future<List<dynamic>> signupservice(String username, String email, String password)async{
    try{
      Response response = await post(
        Uri.parse("http://192.168.0.104:8000/auth/register/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email':email,
          'password':password
        }),
      );
      var data = jsonDecode(response.body);

      if(response.statusCode==200){
        UserProfile userProfile = UserProfile();
        userProfile.id = data["user"]["id"].toString();
        userProfile.username = data["user"]["username"];
        userProfile.email = data["user"]["email"];
        userProfile.displayname = data["profile"]["name"];
        userProfile.bio = data["profile"]["bio"];
        userProfile.gender = data["profile"]["gender"];
        userProfile.profileImage = data["profile"]["image"];
        userProfile.token = data["token"];
        return [response.statusCode, userProfile];
      }else{
        return [response.statusCode, data];
      }
    }catch(e){
      return [500];
    }



  }

  Future<List<dynamic>> loginUserService(String username, String password)async{
    try{
      Response rsp = await post(Uri.parse("http://192.168.0.104:8000/auth/login/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'password':password
          }
          )
      );
      print(rsp.body);

      if(rsp.statusCode==200){
        UserProfile userProfile = UserProfile();
        var data = jsonDecode(rsp.body);
        userProfile.id = data["user"]["id"].toString();
        userProfile.username = data["user"]["username"];
        userProfile.email = data["user"]["email"];
        userProfile.displayname = data["profile"]["name"];
        userProfile.bio = data["profile"]["bio"];
        userProfile.gender = data["profile"]["gender"];
        userProfile.profileImage = data["profile"]["image"];
        userProfile.token = data["token"];

        return [rsp.statusCode, userProfile];

      }else{
        return [rsp.statusCode, jsonDecode(rsp.body)];
      }

    }catch(e){
      print(e);
      return [500];
    }




  }


  Future<List<dynamic>> updateProfileService(String id, String name, String bio, File? image, String gender, UserProfile userProfile)async{

    try{
      var request = MultipartRequest('PUT', Uri.parse("http://192.168.0.104:8000/auth/update/${int.parse(id)}"));
      request.fields['name'] = name;
      request.fields['bio'] = bio;
      request.fields['gender'] = gender;

      //var img = MultipartFile.fromBytes('image', (await rootBundle.load(image.path)).buffer.asUint8List());
      if(image!=null){
        var img = MultipartFile('image', File(image.path).readAsBytes().asStream(), File(image.path).lengthSync(), filename: image.path.split("/").last);

        request.files.add(img);
      }
      var rsp = await request.send();
      rsp.stream.transform(utf8.decoder).listen((event) {
        var data = jsonDecode(event);
        userProfile.displayname = data["name"];
        userProfile.bio = data["bio"];
        userProfile.profileImage = data["image"];
        userProfile.gender=data["gender"];
      });
      return [rsp.statusCode, userProfile];
    }catch(e){
      return [500];
    }


  }


  logoutUserService(String token)async{

    try{
      Response rsp = await post(Uri.parse("http://192.168.0.104:8000/auth/logout/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token'
        },
      );
      return rsp.statusCode;
    }catch(e){
      return 500;
    }


  }

  Future<List<dynamic>>getUserData(String id)async{
    try{
      Response rsp = await get(Uri.parse("http://192.168.0.104:8000/auth/user/${int.parse(id)}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if(rsp.statusCode==200){
        UserProfile userProfile = UserProfile();
        var data = jsonDecode(rsp.body);
        userProfile.id = data["user"]["id"].toString();
        userProfile.username = data["user"]["username"];
        userProfile.email = data["user"]["email"];
        userProfile.displayname = data["profile"]["name"];
        userProfile.bio = data["profile"]["bio"];
        userProfile.gender = data["profile"]["gender"];
        userProfile.profileImage = data["profile"]["image"];

        return [rsp.statusCode, userProfile];
      }
      return [rsp.statusCode, jsonDecode(rsp.body)];
    }catch(e){
      return [500];
    }
  }


}