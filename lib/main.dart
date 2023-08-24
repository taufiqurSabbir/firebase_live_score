import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getdatafromfirebase() async {
    CollectionReference matchscore = firestore.collection('match');
    final DocumentReference documentReference = matchscore.doc('BphMyh468hzEQLztBWjN');
    final data = await documentReference.get();
    log(data.toString());
  }

  @override
  void initState() {
    getdatafromfirebase();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('Match List'),
          ),
      body: StreamBuilder(
        stream: firestore.collection('match').doc('BphMyh468hzEQLztBWjN').snapshots(),
        builder: (context,AsyncSnapshot <DocumentSnapshot<Object?>> snapshot ) {
          if(snapshot.hasData){
            final matches = snapshot.data!;
            String matche_name = matches.get('match_name_1').toString();
            log(matches.toString());
            return Column(
              children: [
                InkWell(onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Match_info(name: matches.get('match_name_1').toString(), matchNum: 'match_1',)));
                },child:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(matches.get('match_name_1'),style: TextStyle(fontSize: 20),),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ) ,),
                InkWell(onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Match_info(name:matches.get('match_name_2').toString(), matchNum: 'match_2',)));
                },child:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(matches.get('match_name_2'),style: TextStyle(fontSize: 20),),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ) ,)

              ],
            );
          }else{
            return CircularProgressIndicator();
          }
        }
      ),
    );
  }
}


class Match_info extends StatefulWidget {
  final String name;
  final String matchNum;
   Match_info({Key? key, required  this.name, required this.matchNum,}) : super(key: key);

  @override
  State<Match_info> createState() => _Match_infoState();
}



class _Match_infoState extends State<Match_info> {


  @override
  void initState() {
    super.initState();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              width: 350,
              height: 180,
              decoration: BoxDecoration(
                  color: Color(0xFFffffff),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow:[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 15.0,
                      spreadRadius: 5.0,
                    )
                  ]
              ),
              child: StreamBuilder(
                  stream: firestore.collection('match').doc('BphMyh468hzEQLztBWjN').snapshots(),
                  builder: (context,AsyncSnapshot <DocumentSnapshot<Object?>> snapshot ) {
                  if(snapshot.hasData){
                    final score = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Text(widget.name,style: TextStyle(fontSize: 30,color: Colors.black54),),
                          Text(widget.matchNum =='match_1' ? score.get('match1_result') :score.get('match2_result'),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                          Text(widget.matchNum =='match_1' ? 'Time: ${score.get('match1_time')}' : 'Time: ${score.get('match2_time')}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text('Total Time: ${score.get('total_time')}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    );
                  }else{
                    return CircularProgressIndicator();
                  }
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}


