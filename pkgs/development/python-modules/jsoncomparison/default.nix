{ lib
, python3Packages
, fetchFromGitHub
, buildPythonPackage
, python
}:
let
  pythonPackages = python.pkgs;
in
buildPythonPackage rec {
  pname = "jsoncomparison";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rugleb";
    repo = "JsonCompare";
    rev = "v${version}";
    hash = "sha256-pRBr5pVmQ1wX2h2N7nuHMi8uJ3qUylPCgkVf92DG3sY=";
  };

  build-system = with pythonPackages; [ poetry-core ];

  nativeCheckInputs = with pythonPackages; [
    # pytestCheckHook
  ];

  pythonImportsCheck = [ "jsoncomparison" ];

  meta = {
    description = "JSON compare utility";
    homepage = "https://github.com/rugleb/JsonCompare";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seedart ];
  };
}
