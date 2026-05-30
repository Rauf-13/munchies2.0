import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/group_order_provider.dart';
import '../../providers/user_provider.dart';
import 'group_cart_screen.dart';

class JoinGroupScreen extends StatefulWidget {
  final String? groupId; // passed from deep link

  const JoinGroupScreen({super.key, this.groupId});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _ctrl = TextEditingController();
  bool _isJoining = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.groupId != null) {
      _ctrl.text = widget.groupId!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _join());
    }
  }

  Future<void> _join() async {
    final groupId = _ctrl.text.trim();
    if (groupId.isEmpty) return;

    setState(() {
      _isJoining = true;
      _error = null;
    });

    final user = context.read<UserProvider>().user!;
    final group = context.read<GroupOrderProvider>();
    final success =
        await group.joinGroupOrder(groupId: groupId, user: user);

    if (mounted) {
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GroupCartScreen()),
        );
      } else {
        setState(() {
          _error = group.error ?? 'Could not join. Check the link and try again.';
          _isJoining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Join a group order',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Paste the link or code your friend shared',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _ctrl,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'munchies.app/g/... or group code',
                hintStyle:
                    TextStyle(color: AppColors.textTertiary, fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                errorText: _error,
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isJoining ? null : _join,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _isJoining
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Join group',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}