import 'package:flutter/material.dart';

class DeveloperInfoView extends StatelessWidget {
  const DeveloperInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;

    var container = Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: const Color(0xffdc3545),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: const Color.fromARGB(255, 88, 21, 28)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 35, bottom: 25),
            child: Text(
              'v1.1 - Alpha',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 32),
            ),
          ),
          Text(
            'Please visit:\n https://github.com/LydianJay/isotech-car-controller-app/releases \n to check for updates',
            maxLines: 3,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black, fontSize: 16),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: IconButton.filledTonal(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );

    return SafeArea(
      child: Container(
        width: scrWidth * 0.9,
        decoration: BoxDecoration(
          color: const Color(0xfff8f9fa),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: const Color.fromARGB(255, 88, 21, 28)),
        ),
        child: container,
      ),
    );
  }
}
