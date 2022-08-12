class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/cd/bd/1c168ee5bd3cb11f157befe9e498ff8d70013d0c239f918a1e8cbd345d12/regipy-3.1.0.tar.gz"
  sha256 "7d65ed76eb0232fd37537751e5ae54264afdeae5678807eee6b6006387ee0377"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0ad6c8c250f34c8f58589cc926b4570419263aa7057a8c3f75ffa8884be2f31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad3006a63cb76f5c7fc60dd00f2a9b79b062566d12e489bbf0cb1f4023598d17"
    sha256 cellar: :any_skip_relocation, monterey:       "eb137800df6c0252e1ea6e691ab64a387d55a1b08f9fcc2b5db8af823962cc65"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9c51479e98a9975574c9d32f291f9b494aaed0709bc672bc0758b11d3e32905"
    sha256 cellar: :any_skip_relocation, catalina:       "fc70b34c8e251c4b50aa231479d2f2bdcd4ef2d2ae2bd59da00eb0cb2b504e2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b91cc6de0a3e66ffbf8de5f13887bdc28dbea6e571db9033292e851e92203da"
  end

  depends_on "libpython-tabulate"
  depends_on "python@3.10"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/e0/b7/a4a032e94bcfdff481f2e6fecd472794d9da09f474a2185ed33b2c7cad64/construct-2.10.68.tar.gz"
    sha256 "7b2a3fd8e5f597a5aa1d614c3bd516fa065db01704c72a1efaaeec6ef23d8b45"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/cf/80/8246892889a36f4a12f719da27c72faea1c2bdb6998afbfffc4284dcd457/pytz-2022.2.tar.gz"
    sha256 "bc824559e43e8ab983426a49525079d186b25372ff63aa3430ccd527d95edc3a"
  end

  resource "test_hive" do
    url "https://raw.githubusercontent.com/mkorman90/regipy/71acd6a65bdee11ff776dbd44870adad4632404c/regipy_tests/data/SYSTEM.xz"
    sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources.reject { |r| r.name == "test_hive" }
    venv.pip_install_and_link buildpath
  end

  test do
    resource("test_hive").stage do
      system bin/"registry-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
      h = JSON.parse(File.read("out.json"))
      assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
      assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
    end
  end
end
