{ lib
, python
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
}:
let
  pythonPackages = python.pkgs;
in
buildPythonPackage rec {
  pname = "buildkite-sdk";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-L6p8utuD7na9wxuSLpG3pkn8brthbdJzi1N3845Ft6I=";
  };

  sourceRoot = "source/sdk/python";

  pyproject = true;

  nativeBuildInputs = with pythonPackages; [
    hatchling
    hatch-vcs
  ];

  dependencies = with pythonPackages; [
    pydantic
    pyyaml
    # jsoncomparison
    requests
    jsonschema
  ];

  nativeCheckInputs = with pythonPackages; [
    pytestCheckHook
    pytest-cov
    pytest-sugar
  ];

  pythonImportsCheck = [ "buildkite_sdk" ];

  disabled = python.pythonOlder "3.10";

  meta = {
    description = "Buildkite SDK for Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seedart ];
  };
}
