import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
class uiScreen extends StatefulWidget {
  const uiScreen({super.key});
  @override
  State<uiScreen> createState() => _uiScreenState();
}
class _uiScreenState extends State<uiScreen> {
  double mass = 0.5;
  double force = 0;
  double last = 0;
  double max = 0;
  double angle = 0;
  StreamSubscription<UserAccelerometerEvent>? accelerometer;
  StreamSubscription<GyroscopeEvent>? gyroscope;

  @override
  void initState() {
    super.initState();
    _initSensors();
  }
  void _initSensors() {
    accelerometer = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        double acceleration = math.sqrt(math.pow(event.x, 2) + math.pow(event.y, 2) + math.pow(event.z, 2)
        );
        force = mass * acceleration;
        if (force > max) max = force;
      });
    });

    gyroscope = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        double magnitude = math.sqrt(math.pow(event.x, 2) + math.pow(event.y, 2) + math.pow(event.z, 2));
        double rotationData = (event.z.abs() > 0.4) ? event.z : 0;
        angle += rotationData * (180 / math.pi) * 0.05;
      });
    });
  }
  @override
  void dispose() {
    accelerometer?.cancel();
    gyroscope?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Tennis Racket"),
        backgroundColor:Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding:EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            cards("Crrent Force", "${force.toStringAsFixed(2)} N",Colors.blue),
            SizedBox(height : 15),

            cards("Max Swing Power","${max.toStringAsFixed(2)} N",Colors.red),
              SizedBox(height : 15),
            cards(" Rotation Angle","${(angle % 360).toStringAsFixed(0)}°",Colors.green),
              SizedBox(height : 15),
            cards("Last Swing Power","${last.toStringAsFixed(2)}N",Colors.orange),
            SizedBox(height:15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:()=>setState(() {
                  last = max;
                  max = 0;
                  angle = 0;
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor :Colors.red,
                  foregroundColor:Colors.white,
                ),
                child:Text("RESET",style:TextStyle(fontSize:18,fontWeight  : FontWeight.bold)),
              ),
            ),
             SizedBox(height:20),
          ],
        ),
      ),
    );
  }
  Widget cards(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      decoration:BoxDecoration(
        color: color,
        borderRadius:BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title,style: TextStyle(fontSize: 16, color: Colors.white)),
          const SizedBox(height:5),
          Text(value,style: TextStyle(fontSize: 32, color: Colors.white)),
        ],
      ),
    );
  }
}