import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/models/campaign.dart';

class CampaignWrapWidget extends StatelessWidget {
  final Campaign campaign;
  const CampaignWrapWidget({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      width: 400,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: MyColors.darkgrey,
          width: 4,
        ),
      ),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16, bottom: 13),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              elevation: 0,
              onPressed: () {},
              child: const Icon(Icons.start),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: (campaign.urlBanner != null)
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                    child: Image.network(campaign.urlBanner!),
                  )
                : Container(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    campaign.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      "Jogado em: ${campaign.updatedAt.toString().substring(0, 10)}"),
                  Text(
                      "Criado em: ${campaign.createdAt.toString().substring(0, 10)}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
