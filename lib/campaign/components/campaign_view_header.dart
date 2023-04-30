import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gm_tools/_core/check_owner_image.dart";
import "package:flutter_gm_tools/models/campaign.dart";
import "package:google_fonts/google_fonts.dart";

import '../../_core/colors.dart';
import "campaign_exit_button.dart";

class CampaignViewHeader extends StatefulWidget {
  final Campaign campaign;
  final Function clickSound;
  final Function clickNotes;
  final Function clickImages;
  final Function clickMaps;
  final Function clickSettings;
  const CampaignViewHeader({
    super.key,
    required this.campaign,
    required this.clickSound,
    required this.clickNotes,
    required this.clickImages,
    required this.clickMaps,
    required this.clickSettings,
  });

  @override
  State<CampaignViewHeader> createState() => _CampaignViewHeaderState();
}

class _CampaignViewHeaderState extends State<CampaignViewHeader> {
  String? urlOwnerImage;

  bool isRetracted = false;

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
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: (isRetracted) ? 0 : 270,
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
              Visibility(
                visible: !isRetracted,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 500,
                    height: 75,
                    decoration: BoxDecoration(
                      color: MyColors.darkgrey.withAlpha(200),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.campaign.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            color: MyColors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.inconsolata().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                            const SizedBox(width: 8),
                            InkWell(
                              onTapDown: (details) {
                                Clipboard.setData(
                                  ClipboardData(
                                      text: widget.campaign.enterCode),
                                ).then((value) {
                                  showMenu(
                                    context: context,
                                    position: RelativeRect.fromRect(
                                        details.globalPosition &
                                            const Size(40, 40),
                                        Offset.zero & const Size(10, 10)),
                                    items: [
                                      const PopupMenuItem(
                                          child: Text("Copiado!")),
                                    ],
                                  );
                                });
                              },
                              onTap: () {},
                              child: const Icon(
                                Icons.copy,
                                size: 14,
                                color: MyColors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SelectableText(
                              widget.campaign.enterCode,
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
              ),
              const CampaignExitButton(),
            ],
          ),
        ),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.clickSound();
                      },
                      icon: const Icon(Icons.audiotrack_rounded),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        widget.clickNotes();
                      },
                      icon: const Icon(Icons.note),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        widget.clickImages();
                      },
                      icon: const Icon(Icons.image),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        widget.clickMaps();
                      },
                      icon: const Icon(Icons.map),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        widget.clickSettings();
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    (!isRetracted)
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                  onPressed: () {
                    setState(
                      () {
                        isRetracted = !isRetracted;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
