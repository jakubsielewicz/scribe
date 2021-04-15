import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'transition_route_observer.dart';
import 'widgets/fade_in.dart';
import 'constants.dart';
import 'widgets/animated_numeric_text.dart';
import 'widgets/round_button.dart';

class PatientSearchScreen extends StatefulWidget {
  static const routeName = '/patientsearch';

  @override
  _PatientSearchScreenState createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacementNamed('/')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
  }

  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  AnimationController? _loadingController;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
      parent: _loadingController!,
      curve: headerAniInterval,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context) as PageRoute<dynamic>?);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final menuBtn = IconButton(
      color: theme.accentColor,
      icon: const Icon(FontAwesomeIcons.bars),
      onPressed: () {},
    );
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: theme.accentColor,
      onPressed: () => _goToLogin(context),
    );
    final title = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Hero(
              tag: Constants.logoTag,
              child: Image.asset(
                'assets/images/logo2-tri-scribe.png',
                filterQuality: FilterQuality.high,
                height: 30,
              ),
            ),
          ),
          /*HeroText(
            Constants.appName,
            tag: Constants.titleTag,
            viewState: ViewState.shrunk,
            style: LoginThemeHelper.loginTextStyle,
          ),*/
          SizedBox(width: 20),
        ],
      ),
    );

    return AppBar(
      leading: FadeIn(
        controller: _loadingController,
        offset: .3,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.startToEnd,
        child: menuBtn,
      ),
      actions: <Widget>[
        FadeIn(
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
          child: signOutBtn,
        ),
      ],
      title: title,
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    // final primaryColor = Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor =
        Colors.primaries.where((c) => c == theme.accentColor).first;

    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have',
                  style: theme.textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: accentColor.shade400,
                  ),
                ),
                SizedBox(width: 5),
                AnimatedNumericText(
                  initialValue: 1,
                  targetValue: 7,
                  curve: Interval(0, 1, curve: Curves.easeOut),
                  controller: _loadingController!,
                  style: theme.textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: accentColor.shade400,
                  ),
                ),
                Text(
                  ' new notifications',
                  style: theme.textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w300,
                    color: accentColor.shade400,
                  ),
                ),
              ],
            ),
            _buildButton(
              icon: Icon(Icons.notification_important),
              label: 'View all',
              interval: Interval(0, 0.75),
            ),
            //Text('View all', style: theme.textTheme.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {Widget? icon, String? label, required Interval interval}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: ElasticOutCurve(0.42),
      ),
      onPressed: () {},
    );
  }

  Widget _buildDashboardGrid() {
    const step = 0.04;
    const aniInterval = 0.75;

    return GridView.count(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 20,
      ),
      childAspectRatio: .9,
      crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        _buildButton(
          icon: Icon(FontAwesomeIcons.user),
          label: 'Patient',
          interval: Interval(0, aniInterval),
        ),
        _buildButton(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Appointment',
          interval: Interval(step, aniInterval + step),
        ),
        _buildButton(
          icon: Icon(Icons.perm_contact_cal_rounded),
          label: 'Contacts',
          interval: Interval(step * 2, aniInterval + step * 2),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.chartLine),
          label: 'Analytics',
          interval: Interval(0, aniInterval),
        ),
        _buildButton(
          icon: Icon(Icons.approval),
          label: 'Approval',
          interval: Interval(step, aniInterval + step),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.history),
          label: 'History',
          interval: Interval(step * 2, aniInterval + step * 2),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.ellipsisH),
          label: 'Other',
          interval: Interval(0, aniInterval),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.search, size: 20),
          label: 'Search',
          interval: Interval(step, aniInterval + step),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.slidersH, size: 20),
          label: 'Settings',
          interval: Interval(step * 2, aniInterval + step * 2),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildDebugButtons() {
    const textStyle = TextStyle(fontSize: 12, color: Colors.white);

    return Positioned(
      bottom: 0,
      right: 0,
      child: Row(
        children: <Widget>[
          MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Colors.red,
            onPressed: () => _loadingController!.value == 0
                ? _loadingController!.forward()
                : _loadingController!.reverse(),
            child: Text('loading', style: textStyle),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(theme),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor.withOpacity(.1),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 40),
                    Expanded(
                      flex: 2,
                      child: _buildHeader(theme),
                    ),
                    Expanded(
                      flex: 8,
                      /*child: ShaderMask(
                        // blendMode: BlendMode.srcOver,
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            tileMode: TileMode.clamp,
                            colors: <Color>[
                              Colors.white,
                              Colors.white,
                              Colors.white,
                              Colors.white,
                            ],
                          ).createShader(bounds);
                        },*/
                      child: _buildDashboardGrid(),
                    ),
                    //    ),
                  ],
                ),
                // if (!kReleaseMode) _buildDebugButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
