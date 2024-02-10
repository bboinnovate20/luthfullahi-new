import 'package:babaloworo/main.dart';
import 'package:babaloworo/shared/form_field.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/notification_database.dart';
import 'package:babaloworo/shared/primary_btn.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NotificationForm extends ConsumerStatefulWidget {
  const NotificationForm({super.key});

  @override
  ConsumerState<NotificationForm> createState() => _NotificationFormState();
}

class _NotificationFormState extends ConsumerState<NotificationForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  submitForm() async {
    setState(() => loading = true);
    try {
      if (_titleController.value.text.isNotEmpty &&
          _descriptionController.value.text.isNotEmpty) {
        final author =
            ref.watch(userAuthentication).getCurrentUser()?.displayName ??
                "Anonymous";
        final notification = NotificationData(
            "",
            _descriptionController.value.text,
            author,
            _titleController.value.text,
            DateTime.now());
        final submit = Database();
        await submit.addNotification(notification);
        sendFCMNotification(notification.title);
        _titleController.clear();
        _descriptionController.clear();
      }
      // ignore: use_build_context_synchronously
      _onSuccessModal(true);
    } catch (e) {
      // ignore: use_build_context_synchronously
      _onSuccessModal(false);
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
      title: "Notification Form",
      isWithBackButton: true,
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                InputCustom(
                    validate: (value) => null,
                    placeholder: "Title",
                    obscure: false,
                    keyboard: TextInputType.text,
                    helperText: "",
                    controller: _titleController),
                InputCustom(
                    maxLines: 12,
                    validate: (value) => null,
                    placeholder: "Description",
                    obscure: false,
                    keyboard: TextInputType.multiline,
                    helperText: "",
                    controller: _descriptionController),
                PrimaryButton(
                    title: "Post",
                    isLoading: loading,
                    action: () => submitForm())
              ],
            ),
          )),
    );
  }

  _onSuccessModal(bool isSuccess) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  const Text("Successfully Posted"),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Icon(Icons.check, color: Colors.green, size: 50),
                  ),
                  PrimaryButton(
                      title: "Go to Dashboard",
                      action: () => PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const BottomNavigation(),
                          withNavBar: false))
                ],
              ),
            ));
  }
}
