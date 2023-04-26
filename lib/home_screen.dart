
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatelessWidget
{

  var waterController = TextEditingController();
   @override
   Widget build(BuildContext context)
  {
     List<ChartData> chartData = [ ] ;

    return Scaffold(
      appBar: AppBar(
       // leading: Icon(Icons.menu,),
        title: Text(
          'Tracker App',
        ),
        actions: [
          IconButton(onPressed: onNotification, icon: Icon(Icons.notification_important))
        ],
      ),
      body: StreamBuilder<List<SolidDetails>>(
        stream: readData(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
          {
            return Text(snapshot.error.toString());
          }
          else if(snapshot.hasData)
          {
          final data = snapshot.data!;
          // var doc = data[0];
          data.forEach((element) {
            chartData = [
              ChartData('Temperature', element.Temperature),
              ChartData('Humidity', element.Humidity),
              ChartData('PH', element.PH),
            ];
          });

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
                    SfCircularChart(
                          // Chart title text
                          title: ChartTitle(
                              text: 'Details Of Soil',
                              // Aligns the chart title to left
                              textStyle: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.italic,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                              )
                          ),
                          // Enables the legend
                          legend: Legend(isVisible: true),
                          // type of chart
                          series: <CircularSeries>[
                              // Initialize line series
                            RadialBarSeries<ChartData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  // Render the data label
                                  dataLabelSettings:DataLabelSettings(isVisible : true)
                              )
                            ],
                        ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: waterController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount of water will be",
                        border: OutlineInputBorder(),
                      ),
                      onFieldSubmitted: (value){print(value);},
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      height: 40,
                      color: Colors.green,
                      child: MaterialButton(
                          onPressed: (){
                            print(waterController.text = "300");

                          },
                          child: Text(
                              "Calculate",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14
                              ),
                          ),

                      ),
                    ),
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
      ),

    );
  }
  void onNotification()
  {
    print('Notification Clicked');
  }
   Future createSolidDetails () async
  {
     final doc =   FirebaseFirestore.instance.collection("SoilDetails").doc("LClS8f8ZmGCOEic5ma9W");
     final sd = SolidDetails(
       Humidity:18,
       PH:6,
       Temperature:30
     );

     await doc.set(sd.toJson());
  }
  
  Stream<List<SolidDetails>> readData()=> FirebaseFirestore.instance
      .collection("SoilDetails")
      .snapshots()
      .map((event) => event.docs.map((e) => SolidDetails.fromJson(e.data())).toList());

}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;

}

class SolidDetails{
  final double Humidity;
  final double PH;
  final double Temperature;

  SolidDetails({
    required this.Humidity,
    required this.PH,
    required this.Temperature
});

  Map<String , dynamic> toJson ()=>
      {
        "Humidity":Humidity,
        "PH":PH,
        "Temperature":Temperature
      };
  static SolidDetails fromJson(Map<String , dynamic> json) =>SolidDetails(
      Humidity: json["Humidity"],
      PH: json["PH"],
      Temperature: json["Temperature"]
  );

}