/*
 * Jakefile
 * Marist Connect
 *
 * Created by You on December 16, 2012.
 * Copyright 2012, Your Company All rights reserved.
 */

var ENV = require("system").env,
    FILE = require("file"),
    JAKE = require("jake"),
    task = JAKE.task,
    FileList = JAKE.FileList,
    app = require("cappuccino/jake").app,
    configuration = ENV["CONFIG"] || ENV["CONFIGURATION"] || ENV["c"] || "Debug",
    OS = require("os");

app ("MaristConnect", function(task)
{
    task.setBuildIntermediatesPath(FILE.join("Build", "MaristConnect.build", configuration));
    task.setBuildPath(FILE.join("Build", configuration));

    task.setProductName("Marist Connect");
    task.setIdentifier("com.yourcompany.MaristConnect");
    task.setVersion("1.0");
    task.setAuthor("Your Company");
    task.setEmail("feedback @nospam@ yourcompany.com");
    task.setSummary("Marist Connect");
    task.setSources((new FileList("**/*.j")).exclude(FILE.join("Build", "**")));
    task.setResources(new FileList("Resources/**"));
    task.setIndexFilePath("index.html");
    task.setInfoPlistPath("Info.plist");

    if (configuration === "Debug")
        task.setCompilerFlags("-DDEBUG -g");
    else
        task.setCompilerFlags("-O");
});

task ("default", ["MaristConnect"], function()
{
    printResults(configuration);
});

task ("build", ["default"]);

task ("debug", function()
{
    ENV["CONFIGURATION"] = "Debug";
    JAKE.subjake(["."], "build", ENV);
});

task ("release", function()
{
    ENV["CONFIGURATION"] = "Release";
    JAKE.subjake(["."], "build", ENV);
});

task ("run", ["debug"], function()
{
    OS.system(["open", FILE.join("Build", "Debug", "MaristConnect", "index.html")]);
});

task ("run-release", ["release"], function()
{
    OS.system(["open", FILE.join("Build", "Release", "MaristConnect", "index.html")]);
});

task ("deploy", ["release"], function()
{
    FILE.mkdirs(FILE.join("Build", "Deployment", "MaristConnect"));
    OS.system(["press", "-f", FILE.join("Build", "Release", "MaristConnect"), FILE.join("Build", "Deployment", "MaristConnect")]);
    printResults("Deployment")
});

task ("desktop", ["release"], function()
{
    FILE.mkdirs(FILE.join("Build", "Desktop", "MaristConnect"));
    require("cappuccino/nativehost").buildNativeHost(FILE.join("Build", "Release", "MaristConnect"), FILE.join("Build", "Desktop", "MaristConnect", "MaristConnect.app"));
    printResults("Desktop")
});

task ("run-desktop", ["desktop"], function()
{
    OS.system([FILE.join("Build", "Desktop", "MaristConnect", "MaristConnect.app", "Contents", "MacOS", "NativeHost"), "-i"]);
});

function printResults(configuration)
{
    print("----------------------------");
    print(configuration+" app built at path: "+FILE.join("Build", configuration, "MaristConnect"));
    print("----------------------------");
}
