import 'package:electrocare/components/drawer.dart';
import 'package:electrocare/repository/controller/colorController.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> with SingleTickerProviderStateMixin {
  Future<void> _launchurlWasp() async {
    Uri _url = Uri.parse('https://whatsapp.com/');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchurlInsta() async {
    Uri _url =
        Uri.parse('https://instagram.com/scan_feast?igshid=ZDdkNTZiNTM=');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchurlFacebook() async {
    Uri _url = Uri.parse(
        'https://www.facebook.com/profile.php?id=100090994873352&mibextid=ZbWKwL');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<void> _launchurlTwitter() async {
    Uri _url = Uri.parse('https://twitter.com/');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final color = ColorController.instance;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: color.black, size: w * 0.075),
      ),
      drawer: DrawerCom.instance.drawer,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "About Us",
                    style: TextStyle(
                        fontSize: w * 0.06, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: w * 0.4,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Our Story',
                          style: TextStyle(
                              fontSize: w * 0.045, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'At Scan Feast, we believe that food brings people together. That\'s why we\'re dedicated to serving delicious meals made from fresh, locally-sourced ingredients. Our chefs are passionate about creating dishes that are not only flavorful, but also healthy and sustainable.',
                          style: TextStyle(fontSize: w * 0.04),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Meet the Team',
                style:
                    TextStyle(fontSize: w * 0.05, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  '- Pankaj Rawat',
                  style: TextStyle(
                      fontSize: w * 0.04, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  '- Chirag Jathan',
                  style: TextStyle(
                      fontSize: w * 0.04, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  '- Swastik Sahu',
                  style: TextStyle(
                      fontSize: w * 0.04, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'We are a family-owned restaurant that has been serving our community for over 10 years. Our mission is to provide the highest quality food and service to ensure our customers have an enjoyable dining experience. '
                  '\n\nCome and join us for a meal today!',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: w * 0.04,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      "Follow us on: ",
                      style: TextStyle(
                          fontSize: w * 0.045, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Color.fromRGBO(37, 211, 102, 1),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlWasp();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.facebookF,
                            color: Color(0xFFF03b5998),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlFacebook();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.instagram,
                            color: Color.fromRGBO(255, 87, 51, 1.0),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlInsta();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.twitter,
                            color: Color(0xFFF00acee),
                            size: 35,
                          ),
                          onPressed: () {
                            _launchurlTwitter();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '07, New Road, Mumbai',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Hours:',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mon-Fri: 11am - 9pm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
