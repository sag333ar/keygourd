import 'package:flutter/material.dart';
import 'package:keygourd/core/commons/widgets/text_button.dart';
import 'package:keygourd/core/models/user_key_model.dart';
import 'package:keygourd/core/res/app_life_cycle_observer.dart';
import 'package:keygourd/core/res/constants/constants.dart';
import 'package:keygourd/core/utilities/app_page_route.dart';
import 'package:keygourd/core/utilities/enum.dart';
import 'package:keygourd/feature/add_user/view/add_user_view.dart';
import 'package:keygourd/feature/dashboard/controller/dashboard_controller.dart';
import 'package:keygourd/feature/dashboard/widgets/data_body.dart';
import 'package:provider/provider.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({super.key, required this.appPin});

  final String appPin;

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  late final AppLifecycleObserver appLifecycleObserver;
  late final DashBoardController controller;

  @override
  void initState() {
    controller = DashBoardController(appPin: widget.appPin);
    appLifecycleObserver = AppLifecycleObserver(context: context);
    WidgetsBinding.instance.addObserver(appLifecycleObserver);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(appLifecycleObserver);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (context, child) => Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              onPressed: _pushToAddUserCallBack, icon: const Icon(Icons.add))
        ]),
        body: Padding(
          padding: kScreenPadding,
          child: Selector<DashBoardController, ViewState>(
            selector: (_, myType) => myType.viewState,
            builder: (context, state, child) {
              if (state == ViewState.data) {
                return DashBoardDataBody(controller: controller);
              } else if (state == ViewState.empty) {
                return StyledTextButton(
                  onPressed: _pushToAddUserCallBack,
                  text: "Add Account",
                );
              } else if (state == ViewState.error) {
                return const Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.white),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _pushToAddUserCallBack() async {
    List? result = await Navigator.push(
      context,
      AppPageRoute.defaultPageRoute(
        AddUserView(
          appPin: widget.appPin,
          keyType: KeyType.posting,
          usersKeys: controller.listOfUsersKeys,
        ),
      ),
    );
    if (result != null) {
      controller.addUser(result.first);
    }
  }
}
