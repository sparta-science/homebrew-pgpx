#!/usr/bin/env bash
app_version=$1
arm64_sha=$2
amd64_sha=$3

if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

class="$(tr '[:lower:]' '[:upper:]' <<< ${APP:0:1})${APP:1}"

read -r -d '' formula_tmpl <<'EOF'
class {class} < Formula
  desc "Port monitoring tool that proxies traffic between a client and the tunnel"
  homepage "{homepage}"
  version "{app_version}"
  license "{license}"

  if Hardware::CPU.arm?
    url "{homepage}/releases/download/v#{version}/{app}-darwin-arm64"
    sha256 "{arm64_sha}"
  else
    url "{homepage}/releases/download/v#{version}/{app}-darwin-amd64"
    sha256 "{amd64_sha}"
  end

  def install
    bin.install "{app}-#{Hardware::CPU.arm? ? "darwin-arm64" : "darwin-amd64"}" => "{app}"
  end

  test do
    assert_match "{app} version v#{version}", shell_output("#{bin}/{app} --version")
  end
end
EOF

if [ -z "$app_version" ] || [ -z "$arm64_sha" ] || [ -z "$amd64_sha" ]; then
  echo "Usage: update_formula.sh <app_version> <arm_sha> <amd64_sha>"
  exit 1
fi

formula=$(echo "${formula_tmpl}" | sed 's/{class}/'${class}'/g')
formula=$(echo "${formula}" | sed 's/{app}/'${APP}'/g')
formula=$(echo "${formula}" | sed 's,{homepage},'${HOMEPAGE}',g')
formula=$(echo "${formula}" | sed 's/{app_version}/'${app_version}'/g')
formula=$(echo "${formula}" | sed 's/{license}/'${LICENSE}'/g')
formula=$(echo "${formula}" | sed 's/{arm64_sha}/'${arm64_sha}'/g')
formula=$(echo "${formula}" | sed 's/{amd64_sha}/'${amd64_sha}'/g')

echo "----------------------------------"
echo "${formula}"
echo "----------------------------------"
echo "Will create file Formula/${APP}.rb"
echo "----------------------------------"

echo "${formula}" > Formula/${APP}.rb
