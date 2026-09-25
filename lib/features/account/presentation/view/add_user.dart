import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocListener, ReadContext;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stock_control_master/core/theme/app_theme_colors.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_bloc.dart';
import 'package:stock_control_master/features/account/presentation/bloc/account_event.dart'
    show ClearAccountMessage, LoadPendingInvitations, SendInvitePressed;
import 'package:stock_control_master/features/account/presentation/bloc/account_state.dart';
import 'package:stock_control_master/shared/widgets/atoms/add_employee_button.dart';
import 'package:stock_control_master/shared/widgets/atoms/invite_employee_bottom_sheet.dart';
import 'package:stock_control_master/shared/widgets/atoms/pending_invitations_section.dart';

class AddPeoplePage extends StatefulWidget {
  const AddPeoplePage({super.key});

  static const routeName = '/add-people';

  @override
  State<AddPeoplePage> createState() => _AddPeoplePageState();
}

class _AddPeoplePageState extends State<AddPeoplePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isInviteSheetOpen = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AccountBloc>().add(const LoadPendingInvitations());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  void _sendInvite(BuildContext context) {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;

    if (!isValid) return;

    context.read<AccountBloc>().add(
      SendInvitePressed(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      ),
    );
  }

  void _clearInviteForm() {
    _nameController.clear();
    _emailController.clear();
    _formKey.currentState?.reset();
  }

  bool _isSuccessMessage(String message) {
    final lower = message.toLowerCase();

    return lower.contains('sent') ||
        lower.contains('success') ||
        lower.contains('resent') ||
        lower.contains('invite');
  }

  Future<void> _openInviteSheet(BuildContext context) async {
    if (_isInviteSheetOpen) return;

    _isInviteSheetOpen = true;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            return InviteEmployeeBottomSheet(
              formKey: _formKey,
              nameController: _nameController,
              emailController: _emailController,
              requiredValidator: _requiredValidator,
              emailValidator: _emailValidator,
              isSending: state.isSendingInvite,
              onSend: () => _sendInvite(context),
            );
          },
        );
      },
    );

    _isInviteSheetOpen = false;
  }

  void _closeInviteSheetIfOpen() {
    if (!_isInviteSheetOpen) return;

    _isInviteSheetOpen = false;

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return BlocListener<AccountBloc, AccountState>(
      listenWhen: (previous, current) =>
          previous.accountMessage != current.accountMessage,
      listener: (context, state) {
        final message = state.accountMessage?.trim();

        if (message == null || message.isEmpty) return;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(message),
            ),
          );

        if (_isSuccessMessage(message)) {
          _clearInviteForm();
          _closeInviteSheetIfOpen();
          context.read<AccountBloc>().add(const LoadPendingInvitations());
        }

        context.read<AccountBloc>().add(const ClearAccountMessage());
      },
      child: Scaffold(
        backgroundColor: appColors.pageBackground,
        appBar: AppBar(
          backgroundColor: appColors.pageBackground,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 16.w,
          title: Text(
            'People',
            style: theme.textTheme.titleLarge?.copyWith(
              color: appColors.primaryText,
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: AddEmployeeButton(onTap: () => _openInviteSheet(context)),
            ),
          ],
        ),
        body: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            return SafeArea(
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  context.read<AccountBloc>().add(
                    const LoadPendingInvitations(),
                  );
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 24.h),
                      sliver: SliverToBoxAdapter(
                        child: PendingInvitationsSection(state: state),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
