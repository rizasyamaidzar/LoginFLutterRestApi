import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logincopilot/login_response/login_response.dart';

void main() {
  runApp(const MyApp());
}

Future<LoginResponse> doLogin(String identifier,String password) async {
  final response = await http.post(Uri.parse('http://localhost:1337/api/auth/local'),
  headers: <String, String>{
    'Content-type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(<String, String>{
    "identifier" : identifier,
    "password" : password
  }),
  );

  if(response.statusCode==200){
    return LoginResponse.fromJson(response.body);
  }else {
    throw Exception('Failed to Login');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<LoginResponse>? _loginResponse;

  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: AppBar(    
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(      
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<LoginResponse>(
            future: _loginResponse, 
            builder: (context, snapshot){

              if(snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();  
              }

              if(snapshot.hasData){
                return Text(snapshot.data!.jwt.toString());
              }else if(snapshot.hasError){
                return Text('${snapshot.error}');
              }
              return SizedBox();
            }
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Identifier'
            ),
            controller: _identifierController,
          ),

          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password'
            ),
            obscureText: true,
            controller: _passwordController,
          ),

          ElevatedButton(
            onPressed: (){
              setState(() {
              _loginResponse = doLogin(_identifierController.text, _passwordController.text);
              });
            },
           child:Text('Login') 
           ),

          
        ]
      ),
      
    );
  }
}
