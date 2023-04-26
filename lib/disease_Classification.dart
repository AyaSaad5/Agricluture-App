import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DiseaseScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    var dis ;
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu,),
        title: Text(
          'Disease Classification',
        ),
        actions: [
          IconButton(onPressed: onNotification, icon: Icon(Icons.notification_important))
        ],
      ),
      body:
             StreamBuilder<List<Disease>>(
               stream: readData(),
               builder: (context, snapshot) {
                 if (snapshot.hasError)
                 {
                   return Text(snapshot.error.toString());
                 }
                 else if(snapshot.hasData)
                   {
                     final data = snapshot.data!;
                     dis = data[0];

                   }
                 return Container(
                  color: Colors.lightGreen[300],
                  width: double.infinity,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:MainAxisAlignment.center ,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Image.network("${dis.Image}" , width: 300, height: 300,),
                          SizedBox(height: 30),
                          Text("${dis.Name}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14
                          ),),
                          SizedBox(height: 25),
                          // Container(
                          //   width: double.infinity,
                          //   height: 40,
                          //   color: Colors.green,
                          //   child: MaterialButton(
                          //     onPressed: (){
                          //       print( "300");
                          //
                          //     },
                          //     child: Text(
                          //       "View More",
                          //       style: TextStyle(
                          //           color: Colors.white70,
                          //           fontSize: 14
                          //       ),
                          //     ),
                          //
                          //   ),
                          // ),
                          SizedBox(height: 25),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(width: 50,),
                              Text(
                                  "Be Green"
                              ),
                              Text(
                                "Thank You",
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              SizedBox(width: 50,),
                            ],
                          )

                        ],
                      ),
                    ),
                  ),
            );
               }
             )


      );


  }

void onNotification()
{
  print('Notification Clicked');
}

  Stream<List<Disease>> readData()=> FirebaseFirestore.instance
      .collection("DiseaseClassification")
      .snapshots()
      .map((event) => event.docs.map((e) => Disease.fromJson(e.data())).toList());

}

class Disease{
  final String Image;
  final String Name;


  Disease({
    required this.Image,
    required this.Name,

  });

  Map<String , dynamic> toJson ()=>
      {
        "Image":Image,
        "Name":Name,

      };
  static Disease fromJson(Map<String , dynamic> json) =>Disease(
      Image: json["Image"],
      Name: json["Name"],
  );

}