import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/models/pricelist.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:reservation_app/services/firestore_database.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kButtonColor,
        title: Text(
          'Studio Astrid',
          style: kGoogleFonts.copyWith(fontSize: 30),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: const [
                ContactInfo(),
                SizedBox(
                  height: 10,
                ),
                ImageGallery(),
                SizedBox(
                  height: 10,
                ),
                StudioAstridPricelist(),
              ],
            )),
      ),
    );
  }
}

// TODO transfer this to firebase
List<String> images = [
  'assets/images/img1.jpg',
  'assets/images/img2.jpg',
  'assets/images/img3.jpg',
  'assets/images/img4.jpg',
  'assets/images/img5.jpg',
  'assets/images/img6.jpg'
];

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri instagramUrl =
        Uri.parse('https://www.instagram.com/studio__astrid/');

    final Uri phoneNumber = Uri.parse('tel:0995133414');

    Future<void> launchSocialNetwork({required Uri webpage}) async {
      if (!await launchUrl(webpage)) {
        throw 'Could not launch $webpage';
      }
    }

    Future<void> launchPhoneCall({required Uri phoneNumber}) async {
      if (!await launchUrl(phoneNumber)) {
        throw 'Could not launch $phoneNumber';
      }
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Contact',
            style: kGoogleFonts.copyWith(fontSize: 30),
          ),
        ),
        Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 10,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          color: kBackgroundColor,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Kralja Petra Krešimira IV 8 A, 47000 Karlovac',
                            style: kMainMenuFonts.copyWith(fontSize: 16.0),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () =>
                                    launchSocialNetwork(webpage: instagramUrl),
                                child: const Icon(
                                  FontAwesomeIcons.instagram,
                                  color: Colors.white,
                                  size: 40.0,
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    launchPhoneCall(phoneNumber: phoneNumber),
                                child: const Icon(
                                  FontAwesomeIcons.phone,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ),
                            ],
                          )
                        ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageGallery extends StatelessWidget {
  const ImageGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Image Gallery',
              style: kGoogleFonts.copyWith(fontSize: 30.0),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2.5,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        images[index],
                      )),
                );
              }),
        )
      ],
    );
  }
}

class StudioAstridPricelist extends StatelessWidget {
  const StudioAstridPricelist({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Pricelist',
              style: kGoogleFonts.copyWith(fontSize: 30.0),
            ),
          ),
        ),
        Consumer(builder: (context, ref, child) {
          final pricelist = ref.watch(pricelistProvider);

          return AsyncValueWidget<List<Price>>(
              value: pricelist,
              data: (price) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListView.builder(
                      itemCount: price[0].pricelist.length,
                      itemBuilder: ((context, index) {
                        return GestureDetector(
                          child: ListTile(
                            title: Text(
                              price[0].pricelist[index].service!,
                              style: kMainMenuFonts,
                            ),
                            subtitle: Text(
                              '${price[0].pricelist[index].price!},00 HRK',
                              style: kMainMenuFonts,
                            ),
                          ),
                        );
                      })),
                );
              });
        }),
      ],
    );
  }
}
