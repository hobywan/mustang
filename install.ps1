
# Copyright 2018, Hoby Rakotoarivelo.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# The Software is provided “as is”, without warranty of any kind, express
# or implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement.
# In no event shall the authors or copyright holders be liable for any claim,
# damages or other liability, whether in an action of contract, tort or
# otherwise, arising from, out of or in connection with the software or
# the use or other dealings in the Software.

$settings_root = "";
$detecting_path = "";
$colors_dir = "";

function Set-Paths {
  $settings_root = $Env:USERPROFILE;
  $detecting_path = "config\options\project.default.xml";
  $colors_dir = "config\colors";
}

function Copy-Scheme($IDE, $scheme) {
  $helper = "$settings_root\$IDE\$detecting_path";
  if (Test-Path $helper) {
    $dest = "$settings_root\$IDE\$colors_dir";
    Copy-Item $scheme -Destination $dest;
    if (Test-Path "$dest\$scheme") {
      echo "Mustang scheme successfully installed for $IDE";
    }
  }
}

function Detect-And-Copy() {
  $found = False;
  $list = Get-Childitem $settings_root -Directory -Name;

  foreach ($IDE in $list) {
    if ($IDE -match "^\.?CLion.*$") {
      $Found = true;
      Copy-Scheme $IDE "mustang.clion.icls"
    }

    if ($IDE -match "^\.?(IdeaC|IntelliJ).*$") {
      $Found = true;
      Copy-Scheme $IDE "mustang.idea.icls"
    }
  }

  if (-Not($found)) {
    echo "No supported IDE detected"
    exit 1
  }
}

# Run
Set-Paths
Detect-And-Copy
exit 0
