import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/services/campaing_service.dart';
import 'package:flutter_gm_tools/_core/systems_enum.dart';

import '../../_core/models/campaign.dart';

class SettingsScreen extends StatefulWidget {
  final Campaign campaign;
  const SettingsScreen({super.key, required this.campaign});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _systemRPG = "-";

  @override
  void initState() {
    _systemRPG = widget.campaign.system;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Sistema corrente:"),
              const SizedBox(width: 24),
              DropdownButton(
                items: List.generate(
                  SystemsRPG.countSystems(),
                  (index) => DropdownMenuItem(
                    value: SystemsRPG.getAllSystems()[index],
                    child: Text(SystemsRPG.getLongName(
                        SystemsRPG.getAllSystems()[index])),
                  ),
                ),
                value: _systemRPG,
                onChanged: (value) {
                  setState(() {
                    _systemRPG = value;
                  });
                  updateSystem();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  updateSystem() {
    widget.campaign.system = _systemRPG;
    CampaignService().updateCampaign(widget.campaign);
  }
}
