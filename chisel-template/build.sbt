// See README.md for license details.

ThisBuild / scalaVersion     := "2.13.7"
ThisBuild / version          := "0.1.0"
ThisBuild / organization     := "%ORGANIZATION%"

lazy val root = (project in file("."))
  .settings(
    name := "%NAME%",
    libraryDependencies ++= Seq(
      "edu.berkeley.cs" %% "chisel3" % "3.5.4",
      "edu.berkeley.cs" %% "chiseltest" % "0.5.2" % "test"
    ),
    scalacOptions ++= Seq(
      "-Xsource:2.13",
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit"
      //"-P:chiselplugin:useBundlePlugin"
    ),
    addCompilerPlugin("edu.berkeley.cs" % "chisel3-plugin" % "3.5.4" cross CrossVersion.full),
    //addCompilerPlugin("org.scalamacros" % "paradise" % "2.1.1" cross CrossVersion.full)
  )
