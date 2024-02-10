import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class Ads extends StatelessWidget {
  const Ads({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: CarouselSlider(
        options: CarouselOptions(height: 400.0, autoPlay: true),
        items: [
          const EachAds(
            name: "ads1",
            url: "https://www.octramarket.com",
          ),
          const EachAds(
            name: "ads2",
            url: "https://www.octragon.com",
          ),
          const EachAds(
            name: "ads3",
            url: "https://www.octramarket.com",
          ),
          const EachAds(
            name: "ads4",
            url: "https://www.octramarket.com",
          ),
          // const AdsG(
          //     adSize: AdSize(width: 50, height: 70),
          //     adUnitId: 'ca-app-pub-4927963111725264/5092769291')
        ].map((eachAds) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: eachAds);
            },
          );
        }).toList(),
      ),
    );
    // CarouselSlider(
    //     items: const [Text("dfa;jdfakdsf "), Text("djfkladjf;ad")],
    //     options: CarouselOptions(
    //       height: 400,
    //       aspectRatio: 16 / 9,
    //       viewportFraction: 0.8,
    //       initialPage: 0,
    //       enableInfiniteScroll: true,
    //       reverse: false,
    //       autoPlay: true,
    //       autoPlayInterval: const Duration(seconds: 3),
    //       autoPlayAnimationDuration: const Duration(milliseconds: 800),
    //       autoPlayCurve: Curves.fastOutSlowIn,
    //       enlargeCenterPage: true,
    //       enlargeFactor: 0.3,
    //       scrollDirection: Axis.horizontal,
    //     ));
  }
}

class EachAds extends StatefulWidget {
  final String name;
  final String url;

  const EachAds({super.key, required this.name, required this.url});

  @override
  State<EachAds> createState() => _EachAdsState();
}

class _EachAdsState extends State<EachAds> {
  BannerAd? ad;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(widget.url))) {
          await launchUrl(Uri.parse(widget.url));
        } else {
          throw 'Could not launch ${widget.url}';
        }
      },
      child: Container(
        decoration: const BoxDecoration(),
        child: Image.asset(
          "assets/images/${widget.name}.jpeg",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class AdsG extends StatefulWidget {
  final AdSize adSize;
  final String adUnitId;
  const AdsG({super.key, required this.adSize, required this.adUnitId});

  @override
  State<AdsG> createState() => _AdsGState();
}

class _AdsGState extends State<AdsG> {
  BannerAd? _bannerAd;

  void loadAd() async {
    await (MobileAds.instance.initialize());
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null
        ? AdWidget(ad: _bannerAd!)
        : const EachAds(
            name: "ads1",
            url: "https://www.octramarket.com",
          );
  }
}
