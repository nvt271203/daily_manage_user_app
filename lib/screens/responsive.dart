import 'package:daily_manage_user_app/screens/format_responsive.dart';
import 'package:flutter/material.dart';

class Responsive extends StatefulWidget {
  const Responsive({super.key});

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // child: LayoutBuilder(
        //   builder: (_, constraints) {
        //     print('👉 maxWidth = ${constraints.maxWidth}');
        //     if (constraints.maxWidth >= 1024) {
        //       return const Desktop();
        //     } else if (constraints.maxWidth < 1024 &&
        //         constraints.maxWidth >= 768) {
        //       return const Tablet();
        //     } else {
        //       return const Mobile();
        //     }
        //   },
        // ),
        child: FormatResponsive(desktopWidget: Desktop(), tabletWidget: Tablet(), mobileWidget: Mobile()),
      ),
    );
  }
}

class Desktop extends StatefulWidget {
  const Desktop({super.key});

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //FIRST ROW
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 300,
                color: Colors.blue.withOpacity(0.2),
                child: Text('Box 1'),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 70,
                      color: Colors.blue.withOpacity(0.2),
                      child: Text('Box 2'),
                    ),
                    SizedBox(height: 20),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.blue.withOpacity(0.2),
                              child: Text('Box 3'),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              height: 200,
                              color: Colors.blue.withOpacity(0.2),
                              child: Text('Box 4'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 200,
                color: Colors.blue.withOpacity(0.2),
                child: Text('Box 4'),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                height: 200,
                color: Colors.blue.withOpacity(0.2),
                child: Text('Box 5'),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}

class Tablet extends StatefulWidget {
  const Tablet({super.key});

  @override
  State<Tablet> createState() => _TabletState();
}

class _TabletState extends State<Tablet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //FIRST ROW
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 300,
                color: Colors.blue.withOpacity(0.2),
                child: Text('Box 1'),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        color: Colors.blue.withOpacity(0.2),
                        child: Text('Box 2'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: Colors.blue.withOpacity(0.2),
                        child: Text('Box 3'),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        width: double.infinity,

                        color: Colors.blue.withOpacity(0.2),
                        child: Text('Box 4'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 200,
                color: Colors.blue.withOpacity(0.2),
                child: Text('Box 4'),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                height: 200,
                color: Colors.blue.withOpacity(0.2),
                child: Text('Box 5'),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ],
    );
  }
}

class Mobile extends StatefulWidget {
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //FIRST ROW
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.blue.withOpacity(0.2),
            child: Text('Box 1'),
          ),
          SizedBox(height: 20),
          Container(
            height: 70,
            width: double.infinity,
            color: Colors.blue.withOpacity(0.2),
            child: Text('Box 2'),
          ),
          SizedBox(height: 20),

          Container(
            height: 200,
            width: double.infinity,

            color: Colors.blue.withOpacity(0.2),
            child: Text('Box 3'),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            width: double.infinity,

            color: Colors.blue.withOpacity(0.2),
            child: Text('Box 4'),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.blue.withOpacity(0.2),
            child: Text('Box 4'),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            width: double.infinity,
              
            color: Colors.blue.withOpacity(0.2),
            child: Text('Box 5'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
