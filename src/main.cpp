// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>

#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QUrl>
#ifdef Q_OS_ANDROID
#include <GuiQApplication>
#else
#include <QApplication>
#endif

#include "app.h"
#include "version-citam.h"
#include <KAboutData>
#include <KLocalizedContext>
#include <KLocalizedString>

#include "controllers/logincontroller.h"

#include "citamconfig.h"

#ifdef Q_OS_ANDROID
Q_DECL_EXPORT
#endif
int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef Q_OS_ANDROID
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle(QStringLiteral("org.kde.breeze"));
#else
    QApplication app(argc, argv);

    // Default to org.kde.desktop style unless the user forces another style
    if (qEnvironmentVariableIsEmpty("QT_QUICK_CONTROLS_STYLE")) {
        QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
    }
#endif

#ifdef Q_OS_WINDOWS
    if (AttachConsole(ATTACH_PARENT_PROCESS)) {
        freopen("CONOUT$", "w", stdout);
        freopen("CONOUT$", "w", stderr);
    }

    QApplication::setStyle(QStringLiteral("breeze"));
    auto font = app.font();
    font.setPointSize(10);
    app.setFont(font);
#endif

    KLocalizedString::setApplicationDomain("citam");
    QCoreApplication::setOrganizationName(QStringLiteral("KDE"));

    KAboutData aboutData(
        // The program name used internally.
        QStringLiteral("citam"),
        // A displayable program name string.
        i18nc("@title", "citam"),
        // The program version string.
        QStringLiteral(CITAM_VERSION_STRING),
        // Short description of what the app does.
        i18n("Application Description"),
        // The license this code is released under.
        KAboutLicense::GPL,
        // Copyright Statement.
        i18n("(c) 2023"));
    aboutData.addAuthor(i18nc("@info:credit", "Erick Muuo"),
                        i18nc("@info:credit", "Maintainer"),
                        QStringLiteral("hearteric57@gmail.com"),
                        QStringLiteral("https://yourwebsite.com"));
    aboutData.setTranslator(i18nc("NAME OF TRANSLATORS", "Your names"), i18nc("EMAIL OF TRANSLATORS", "Your emails"));
    KAboutData::setApplicationData(aboutData);
    QGuiApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("org.kde.citam")));

    QQmlApplicationEngine engine;

    auto config = citamConfig::self();

    qmlRegisterSingletonInstance("org.kde.citam", 1, 0, "Config", config);

    qmlRegisterSingletonType("org.kde.citam", 1, 0, "About", [](QQmlEngine *engine, QJSEngine *) -> QJSValue {
        return engine->toScriptValue(KAboutData::applicationData());
    });

    App application;
    qmlRegisterSingletonInstance("org.kde.citam", 1, 0, "App", &application);

    LoginController loginController;
    qmlRegisterSingletonInstance<LoginController>("org.kde.citam", 1, 0, "LoginController", &loginController);

    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
