import 'dart:io' show Platform;

import 'package:stock_control_master/features/account/presentation/widgets/app_version_and_update_card.dart';

import 'package:stock_control_master/features/account/presentation/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:stock_control_master/features/account/presentation/widgets/account_simple_tile.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_bloc.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_event.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_state.dart';
import 'package:stock_control_master/features/account/presentation/widgets/account_company_card.dart';
import 'package:stock_control_master/features/account/presentation/widgets/account_header.dart';
import 'package:stock_control_master/features/account/presentation/widgets/account_profile_tile.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  static const String routeName = 'account';

  Future<String> _appVersionText() async {
    final info = await PackageInfo.fromPlatform();

    final version = info.version.trim();
    final buildNumber = info.buildNumber.trim();

    if (version.isEmpty && buildNumber.isEmpty) return 'Unknown';
    if (buildNumber.isEmpty) return version;

    return '$version ($buildNumber)';
  }

  Future<void> _openStore(BuildContext context) async {
    Uri? uri;

    if (Platform.isAndroid) {
      uri = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.hrmaster.app',
      );

      final fallbackUri = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.hrmaster.app',
      );

      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }

      return;
    }

    if (Platform.isIOS) {
      uri = Uri.parse('https://apps.apple.com/gb/app/hrmaster/id6772557227');

      final fallbackUri = Uri.parse(
        'https://apps.apple.com/gb/app/hrmaster/id6772557227',
      );

      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }

      return;
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Store update is only available on Android or iOS.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
      listenWhen: (previous, current) =>
          previous.showLogoutDialog != current.showLogoutDialog,
      listener: (context, state) async {
        if (!state.showLogoutDialog) return;

        await showAdaptiveDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => AppAlertDialog(
            title: 'Logout',
            message: 'Are you sure you want to logout?',
            showCancel: true,
            onConfirm: () async {
              Navigator.of(context).pop();

              context.read<AccountBloc>().add(const LogoutConfirmed());
            },
          ),
        );

        if (context.mounted) {
          context.read<AccountBloc>().add(const LogoutCancelled());
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final pageBg = theme.scaffoldBackgroundColor;

        final email = state.email.trim();
        final phone = state.phone.trim();

        String subtitle = '';

        if (email.isNotEmpty && phone.isNotEmpty) {
          subtitle = '$email | $phone';
        } else if (email.isNotEmpty) {
          subtitle = email;
        } else if (phone.isNotEmpty) {
          subtitle = phone;
        }

        return Scaffold(
          backgroundColor: pageBg,
          body: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AccountProfileTile(
                          imageAsset: '',
                          imageAssetUrl: state.avatarUrl ?? '',
                          title: state.name,
                          subtitle: subtitle,
                          onTap: () {
                            context.read<AccountBloc>().add(
                              const ProfileImageChangeTapped(),
                            );
                          },
                        ),
                        SizedBox(height: 28.h),
                        AccountCompanyCard(
                          children: [
                            AccountCardTile(
                              icon: Icons.badge_outlined,
                              title: 'Edit profile information',
                              onTap: () {
                                context.read<AccountBloc>().add(
                                  const EditProfileTapped(),
                                );
                              },
                            ),
                            AccountCardTile(
                              icon: Icons.folder_outlined,
                              title: 'Documents',
                              onTap: () {
                                context.read<AccountBloc>().add(
                                  const DocumentsTapped(),
                                );
                              },
                            ),
                            // AccountCardTile(
                            //   icon: Icons.dark_mode_outlined,
                            //   title: 'Dark mode',
                            //   trailing: Switch.adaptive(
                            //     value: state.isDarkMode,
                            //     onChanged: (value) {
                            //       context.read<AccountBloc>().add(
                            //         DarkModeChanged(value),
                            //       );
                            //     },
                            //   ),
                            // ),
                            // if (state.isManager)
                            //   AccountCardTile(
                            //     icon: Icons.people_alt_rounded,
                            //     title: 'People',
                            //     trailingText: 'View all peoples',
                            //     showDivider: true,
                            //     onTap: () {
                            //       Navigator.pushNamed(
                            //         context,
                            //         AllPeoplesPage.routeName,
                            //       );
                            //     },
                            //   ),
                            if (state.isManager)
                              AccountCardTile(
                                icon: Icons.person_add_alt_1_rounded,
                                title: 'Invite',
                                trailingText: 'Add peoples',
                                showDivider: false,
                                onTap: () {
                                  context.read<AccountBloc>().add(
                                    AddPeopleTap(),
                                  );
                                },
                              ),
                          ],
                        ),
                        SizedBox(height: 18.h),
                        AppVersionAndUpdateCard(
                          versionFuture: _appVersionText(),
                          onCheckUpdate: () => _openStore(context),
                        ),
                        SizedBox(height: 18.h),
                        AccountSimpleTile(
                          icon: Icons.logout_rounded,
                          title: 'Log out',
                          isDestructive: true,
                          onTap: () {
                            context.read<AccountBloc>().add(
                              const LogoutTapped(),
                            );
                          },
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 10.h,
                  left: 12.w,
                  right: 12.w,
                  child: AccountHeader(
                    onClose: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
