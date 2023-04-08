import "package:flutter/material.dart";
import "package:flutter_gm_tools/_core/check_owner_image.dart";
import "package:flutter_gm_tools/models/campaign.dart";

import "../../_core/colors.dart";
import "campaign_exit_button.dart";

class CampaignViewHeader extends StatefulWidget {
  final Campaign campaign;
  const CampaignViewHeader({super.key, required this.campaign});

  @override
  State<CampaignViewHeader> createState() => _CampaignViewHeaderState();
}

class _CampaignViewHeaderState extends State<CampaignViewHeader> {
  String? urlOwnerImage;

  @override
  void initState() {
    checkOwnerImage(widget.campaign.ownerId).then((value) {
      setState(() {
        urlOwnerImage = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Stack(
        children: [
          (widget.campaign.urlBanner != null)
              ? Image.network(
                  widget.campaign.urlBanner!,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                )
              : Container(
                  color: Colors.grey,
                  height: 270,
                ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              width: 500,
              height: 75,
              decoration: BoxDecoration(
                color: MyColors.darkgrey.withAlpha(150),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.campaign.name,
                    style: const TextStyle(
                      fontSize: 28,
                      color: MyColors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 4),
                      (urlOwnerImage != null)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                urlOwnerImage!,
                                height: 16,
                                width: 16,
                              ),
                            )
                          : const Icon(
                              Icons.people,
                              size: 16,
                              color: MyColors.white,
                            ),
                      const SizedBox(width: 8),
                      Text(
                        widget.campaign.ownerName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: MyColors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const CampaignExitButton(),
        ],
      ),
    );
  }
}
