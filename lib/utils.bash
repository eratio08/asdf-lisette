#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/ivov/lisette"
TOOL_NAME="lisette"
TOOL_TEST="lis --help"
PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

release_tag() {
	printf "lisette-v%s\n" "$1"
}

release_tarball_url() {
	local version
	version="$1"
	printf "%s/archive/refs/tags/%s.tar.gz\n" "$GH_REPO" "$(release_tag "$version")"
}

list_versions_matching_query() {
	local query
	query="${1:-}"

	if [ -z "$query" ]; then
		list_all_versions
	else
		list_all_versions | awk -v query="$query" 'index($0, query) == 1'
	fi
}

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed -n 's/^lisette-v//p'
}

list_all_versions() {
	list_github_tags
}

resolve_version() {
	local install_type version
	install_type="$1"
	version="$2"

	if [ "$install_type" != "version" ]; then
		printf "%s\n" "$version"
		return
	fi

	case "$version" in
	latest)
		"$PLUGIN_ROOT/bin/latest-stable"
		;;
	latest:*)
		"$PLUGIN_ROOT/bin/latest-stable" "${version#latest:}"
		;;
	*)
		printf "%s\n" "$version"
		;;
	esac
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="$(release_tarball_url "$version")"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3"
	local source_path staging_path install_parent resolved_version
	local -a cargo_args

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	if [ -z "${ASDF_DOWNLOAD_PATH:-}" ]; then
		fail "ASDF_DOWNLOAD_PATH is not set"
	fi

	command -v cargo >/dev/null 2>&1 || fail "cargo is required to build lisette from source"

	resolved_version="$(resolve_version "$install_type" "$version")"
	[ -n "$resolved_version" ] || fail "Could not resolve $version to a Lisette release"

	source_path="$ASDF_DOWNLOAD_PATH"
	staging_path="$(mktemp -d "${TMPDIR:-/tmp}/asdf-${TOOL_NAME}-${resolved_version}.XXXXXX")"
	install_parent="$(dirname "$install_path")"
	cargo_args=(build --release --package lisette --bin lis)

	if [ -n "${ASDF_CONCURRENCY:-}" ]; then
		cargo_args+=(--jobs "$ASDF_CONCURRENCY")
	fi

	cleanup_install() {
		rm -rf "$install_path"
		rm -rf "$staging_path"
	}

	mkdir -p "$staging_path/bin" || {
		cleanup_install
		fail "An error occurred while installing $TOOL_NAME $resolved_version."
	}

	(
		cd "$source_path"
		cargo "${cargo_args[@]}"
	) || {
		cleanup_install
		fail "An error occurred while building $TOOL_NAME $resolved_version."
	}

	cp "$source_path/target/release/lis" "$staging_path/bin/lis" || {
		cleanup_install
		fail "An error occurred while installing $TOOL_NAME $resolved_version."
	}

	chmod +x "$staging_path/bin/lis" || {
		cleanup_install
		fail "An error occurred while installing $TOOL_NAME $resolved_version."
	}

	rm -rf "$install_path"
	mkdir -p "$install_parent" || {
		cleanup_install
		fail "An error occurred while installing $TOOL_NAME $resolved_version."
	}
	mv "$staging_path" "$install_path" || {
		cleanup_install
		fail "An error occurred while installing $TOOL_NAME $resolved_version."
	}

	local tool_cmd
	tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
	test -x "$install_path/bin/$tool_cmd" || {
		cleanup_install
		fail "Expected $install_path/bin/$tool_cmd to be executable."
	}

	echo "$TOOL_NAME $resolved_version installation was successful!"
}
