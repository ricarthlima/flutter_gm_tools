import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          Container(
            alignment: Alignment.topRight,
            child: Container(
              width: 120,
              height: 30,
              decoration: const BoxDecoration(
                color: MyColors.darkgrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    campaign.enterCode,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: MyColors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTapDown: (details) {
                      Clipboard.setData(
                        ClipboardData(text: campaign.enterCode),
                      ).then((value) {
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            details.globalPosition.dx,
                            details.globalPosition.dy,
                            0,
                            0,
                          ),
                          items: [
                            const PopupMenuItem(child: Text("Copiado!")),
                          ],
                        );
                      });
                    },
                    onTap: () {},
                    child: const Icon(
                      Icons.copy,
                      size: 16,
                      color: MyColors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
