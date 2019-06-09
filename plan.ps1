$pkg_name="corretto"
$pkg_origin="winhab"
$pkg_version="11.0.3.7.1-1"
$pkg_description="No-cost, multiplatform, production-ready distribution of OpenJDK"
$pkg_upstream_url="https://aws.amazon.com/corretto/"
$pkg_license=@("GPLv2")
$pkg_maintainer="Jeff Brimager <jbrimager@chef.io>"
$pkg_source="https://d3pxv6yz143wms.cloudfront.net/11.0.3.7.1/amazon-corretto-11.0.3.7.1-1-windows-x64.msi"
$pkg_shasum="5e3ac0c32dc0b6fc37144b5db893c4ca0022dfdb08c50840f86886116a0ab585"
$pkg_build_deps=@("core/lessmsi")
$pkg_bin_dirs=@("bin")
$pkg_lib_dirs=@("lib")

function Invoke-Unpack {
  mkdir "$HAB_CACHE_SRC_PATH/$pkg_dirname"
  Push-Location "$HAB_CACHE_SRC_PATH/$pkg_dirname"
  try {
    lessmsi x (Resolve-Path "$HAB_CACHE_SRC_PATH/$pkg_filename").Path
  }
  finally { Pop-Location }
}

function Invoke-Install {
  Copy-Item "$HAB_CACHE_SRC_PATH/$pkg_dirname/amazon-corretto-$pkg_version-windows-x64/SourceDir/Amazon Corretto/jdk11.0.3_7/*" "$pkg_prefix" -Recurse -Force
  $env:JAVA_HOME = "$HAB_CACHE_SRC_PATH/$pkg_dirname/Amazon Corretto/jdk11.0.3_7/bin"
  $test = Get-Command java | Select-Object Version
  Write-output $test
}

# This isn't always needed
function Invoke-Check() {
  (& "$HAB_CACHE_SRC_PATH/$pkg_dirname/bin/java.exe" --version).StartsWith("java $pkg_version")
}
