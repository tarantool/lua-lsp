class Tarantoollsp < Formula
	desc "LSP server for Tarantool/Lua based codewriters"
	homepage "https://github.com/tarantool/lua-lsp"
  	url "https://download.tarantool.org/tarantool/2.2/src/tarantool-2.2.1.1.tar.gz"
 	sha256 "42c6c61b7d9a2444afd96e4f5e1828da18ea2637d1e9d61dc543436ae48dd87f"
	head "https://github.com/tarantool/lua-lsp.git", :branch => "master"

	# By default, Tarantool from brew includes devel headers
	depends_on "tarantool"
	depends_on "gcc"

	def install
		system "tarantoolctl", "rocks", "make"
		prefix.install "tarantool-lsp", ".rocks", "bin", "3rd-party"
	end
end
