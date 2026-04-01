#!/bin/zsh --no-rcs

export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}"

# Automatically Get Bookmarks Database for Default Profile
case "${releaseChannel}" in
	"firefox")
		readonly versionCode="2656FF1E876E9973"
		;;
	"firefoxDeveloperEdition")
		readonly versionCode="1F42C145FFDD4120"
		;;
	"firefoxNightly")
		readonly versionCode="31210A081F86E80E"
		;;
esac
readonly defaultProfile=$(awk -v versionCode="$versionCode" 'BEGIN {FS="="} $0 ~ versionCode {flag=1} flag && /^Default=Profiles/ {print $2; exit}' "${HOME}/Library/Application Support/Firefox/installs.ini")
readonly bookmarks_file="file://${HOME}/Library/Application Support/Firefox/${defaultProfile}/places.sqlite?immutable=1"

readonly sqlQuery="SELECT p.id, p.url, b.title, p.description, k.keyword, JSON_GROUP_ARRAY(DISTINCT t.title) AS tag_names
FROM moz_places p
JOIN moz_bookmarks b ON b.fk = p.id
JOIN moz_bookmarks t ON t.id = b.parent
LEFT JOIN moz_keywords k ON p.id = k.place_id
GROUP BY p.url;"

readonly raw_query="${1-}"
readonly query="$(printf '%s' "${raw_query}" | tr '\r\n' ' ' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//; s/[[:space:]]\+/ /g')"
readonly fzf_bin="$(command -v fzf 2>/dev/null)"

bookmarks_json="$(
	sqlite3 -json ${bookmarks_file} ${sqlQuery} | jq -cs \
	--arg useDesc "$useDesc" \
	--arg useURL "$useURL" \
	--arg useTag "$useTag" \
	--arg releaseChannel "$releaseChannel" \
	--arg showAllTags "$showAllTags" \
	--arg useQL "$useQL" \
	--arg useKeyword "$useKeyword" \
	'
	[
		.[] | .[] |
		select(.tag_names | contains("Exclude-Alfred") | not) |
		{
			uid: (.id | tostring),
			title: (.title // ""),
			subtitle: "\(.tag_names | fromjson | .[1:] | if .[0] then "[" + (if $showAllTags == "1" then join(", ") else .[0] end) + "] " else "" end)\(.url // "")",
			arg: (.url // ""),
			match: [
				(.title // ""),
				(if $useDesc == "1" then .description else empty end),
				(if $useKeyword == "1" then .keyword else empty end),
				(if $useURL == "1" then .url else empty end),
				(if $useTag == "1" then (.tag_names | fromjson | .[1:] | map("#" + .) | join(" ")) else empty end)
			] | map(select(. != null and . != "")) | join(" "),
			quicklookurl: (if $useQL == "1" then (.url // "") else "" end),
			text: { largetype: "[\(.tag_names | fromjson | .[1:] | join(", "))]\n\n\(.url // "")" },
			icon: { path: "images/\($releaseChannel).png" },
			mods: {
				cmd: {
					subtitle: "⌘↩ Open in secondary browser",
					arg: (.url // ""),
					variables: { bSecondary: true }
				},
				shift: {
					subtitle: (.description // "")
				}
			}
		}
	]
	'
)"

if [[ -z "${bookmarks_json}" || "${bookmarks_json}" == "[]" ]]; then
	cat <<'EOF'
{"items":[{"title":"Search Bookmarks...","subtitle":"You have no bookmarks","valid":false}]}
EOF
	exit 0
fi

if [[ -n "${query}" ]]; then
	if [[ -z "${fzf_bin}" ]]; then
		jq -cn --arg query "${query}" '{
			items: [{
				title: "fzf not found",
				subtitle: "Query was: \($query)",
				valid: false
			}]
		}'
		exit 0
	fi

	filtered_json="$(
		printf '%s' "${bookmarks_json}" | jq -r '
			.[] |
			[
				(.title // "" | gsub("[\\t\\r\\n]"; " ")),
				(.subtitle // "" | gsub("[\\t\\r\\n]"; " ")),
				(.match // "" | gsub("[\\t\\r\\n]"; " ")),
				@json
			] | @tsv
		' | "${fzf_bin}" --filter="${query}" --delimiter=$'\t' --nth=1,2,3 | cut -f4-
	)"
else
	filtered_json="$(printf '%s' "${bookmarks_json}" | jq -c '.[]')"
fi

if [[ -z "${filtered_json}" ]]; then
	jq -cn --arg query "${query}" '{
		items: [{
			title: "No matching bookmarks",
			subtitle: (if $query == "" then "Refine your query" else "No results for: \($query)" end),
			valid: false
		}]
	}'
	exit 0
fi

printf '%s\n' "${filtered_json}" | jq -cs '{items: .}'
