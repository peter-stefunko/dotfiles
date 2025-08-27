#!/bin/bash

display_help() {
    cat <<EOF
Usage: manga-dl.sh [OPTIONS] TITLE [FROM_CHAPTER] [TO_CHAPTER]

Manga Downloader Script
-----------------------
Downloads manga chapters as images and converts them to a PDF.

Arguments:
  TITLE			Manga series title. Cannot be combined with --title.
  			Format: "First-Second-Third" or "First Second Third",
  			case insensitive.
  FROM_CHAPTER		Starting chapter. Cannot be combined with --chapters or --from.
  			Format: integer or decimal, e.g., 5 or 6.5). Default: 1
  TO_CHAPTER		Ending chapter. Cannot be combined with --chaptes or --to.
  			Format: integer or decimal.
  			Default: FROM_CHAPTER, or 9999 if FROM_CHAPTER is not specified.

Options:
  --title NAME		Manga title (alternative to argumnet TITLE).
  --from NUMBER		Starting chapter (alternative to argument FROM_CHAPTER).
  			Sets TO_CHAPTER to 9999 unless specified using --to
  --to NUMBER		Ending chapter (alternative to argument TO_CHAPTER).
  			Sets FROM_CHAPTER to its default 1 unless specified using --from
  --chapters RANGE	Shortcut for specifying both FROM_CHAPTER and TO_CHAPTER at once.
			Accepts "N" (single chapter) or "N,M" (range).
			Sets FROM_CHAPTER to N and TO_CHAPTER to M
			(or N if M is not specified)
			Cannot be combined with --from, --to, or FROM/TO_CHAPTER arguments.
  -o, --output FILE	Custom PDF filename inside DIR. Default: TITLE.pdf
  -O, --output-dir DIR	Directory for output. Default: ~/Downloads/Manga
  -k, --keep-images	Keep downloaded images after creating PDF.
  -n, --no-pdf		Do not create a PDF; only download images.
  -s, --step NUMBER	Step size between chapters. Default: 0.5
  -h, --help		Show this help message and exit.
  -i, --ignore-if-fail	Skip chapters that fail to download and continue with the
			next one instead of exiting the script. Default: false

Examples:
  Download entire series "Oyasumi Punpun":
    manga-dl.sh Oyasumi-Punpun

  Download chapters 5 to 30:
      manga-dl.sh "oyasumi punpun" 5 30

  Download chapter 6.5 only:
      manga-dl.sh dorohedoro 6.5

  Download chapters 1 to 10, keep images, custom PDF name:
      manga-dl.sh -k -o Oyasumi-Punpun_1-10.pdf "Oyasumi Punpun" 1 10

  Use custom output directory:
      manga-dl.sh -O /tmp/manga Blame 1 5

Dependencies:
  curl		Required to check if images exist on the host.
  wget		Required to download individual image files.
  img2pdf	Required to convert downloaded images into a PDF file.

Notes:
  - Flags must appear **before** positional arguments (TITLE [FROM_CHAPTER] [TO_CHAPTER]).
EOF
}

fix_title() {
	local title="$1"

	local title="${title,,}"
	local temp="${title//-/ }"
	local result
	result=$(for word in $temp; do echo -n "${word^}-"; done)
	echo "${result%-}"
}


make_decimal() {
	local num="$1"

	printf "%.1f" "$num"
}

is_integer() {
	local num="$1"

	[[ "$num" =~ ^-?[0-9]+$ ]]
}

is_decimal() {
	local num="$1"

	[[ "$num" =~ ^-?[0-9]*\.[0-9]+$ ]]
}

is_number() {
	local num="$1"

	is_integer "$num" || is_decimal "$num"
}

split_number() {
	local num="$1"

	is_integer "$num" && echo "$num;" && return
	local num_trunc="${num::-2}"
	local decimal="${num: -2}"
	[[ "$decimal" == ".5" ]] || decimal=""
	echo "$num_trunc;$decimal"
}

get_image_name() {
	local chapter="$1" page="$2"

	local ch_trunc ch_decimal ch_split
	ch_split="$(split_number "$chapter")"
	IFS=';' read -r ch_trunc ch_decimal <<< "$ch_split"
	printf "%04d%s-%03d.png" "$ch_trunc" "$ch_decimal" "$page"
}

get_new_host() {
	local image="$1"

	local hosts=(
		"https://hot.planeptune.us"
		"https://official.lowee.us"
		"https://scans.lastation.us"
		"https://scans-hot.planeptune.us"
	)
	local found=0
	for host in "${hosts[@]}"; do
		url="$host/manga/$title"
		if curl -s --head --fail "$url/$image" > /dev/null; then
			found=1
			break
		fi
	done
	[[ "$found" -eq 1 ]]
}

update_progress() {
	local chapter="$1"
	local page="$2"
	local chapters_total="$3"
	local pages_total="$4"

	echo -ne "\033[1A"
	echo -e "\rDownloaded:  $chapters_total chapters [$pages_total pages total]"
	echo -ne "$reset\rDownloading: Chapter $chapter [page $page]\r"
}

download_image() {
	local image="$1"

	local host="$url/$image"
	wget -P "$images_dir" "$host" 1>/dev/null 2>/dev/null
}

output_dir="$HOME/Downloads/Manga"
output_pdf=""
keep_images=false
no_pdf=false
step=0.5
title=""
from=""
to=""
chapters=""
ignore_if_fail=false

for arg in "$@"; do
    shift
    case "$arg" in
	--output)		set -- "$@" -o ;;
	--output-dir)		set -- "$@" -O ;;
	--keep-images)		set -- "$@" -k ;;
	--no-pdf)		set -- "$@" -n ;;
	--step)			set -- "$@" -s ;;
	--help)			set -- "$@" -h ;;
	--title)		set -- "$@" -T ;;
	--from)			set -- "$@" -f ;;
	--to)			set -- "$@" -t ;;
	--chapters)		set -- "$@" -c ;;
	--ignore-if-fail)	set -- "$@" -i ;;
        *)			set -- "$@" "$arg" ;;
    esac
done

help_short="Please refer to manga-dl -h for help"

while getopts "o:O:s:T:f:t:c:knih" opt; do
	case "$opt" in
		o) output_pdf="$OPTARG" ;;
		O) output_dir="$OPTARG" ;;
		k) keep_images=true ;;
		n) no_pdf=true ;;
		s) step="$OPTARG" ;;
		h) display_help; exit 0 ;;
		T) title="$OPTARG" ;;
		f) from="$OPTARG" ;;
		t) to="$OPTARG" ;;
		c) chapters="$OPTARG" ;;
		i) ignore_if_fail=true ;;
		\?) echo -e "Error: Invalid option: -$OPTARG\n$help_short" >&2; exit 1 ;;
	esac
done
shift $((OPTIND-1))

is_number "$step" || { echo "Error: Step must be an integer or a decimal. $help_short"; exit 1; }

if [[ -n "$title" && -n "$1" ]]; then
	echo "Error: Cannot use both --title and positional argument for TITLE"
	echo "$help_short"
    exit 1
elif [[ -n "$1" ]]; then
	title="$(fix_title "$1")"
elif [[ -n "$title" ]]; then
	title="$(fix_title "$title")"
else
	echo "Error: Missing TITLE (use --title or positional argument)"
	echo "$help_short"
	exit 1
fi

if [[ -n "$chapters" ]]; then
	if [[ -n "$from" || -n "$to" || -n "$2" || -n "$3" ]]; then
		echo "Error: Cannot use --chapters together with --from, --to, or positional FROM/TO"
		echo "$help_short"
		exit 1
	fi
	if [[ "$chapters" == *,* ]]; then
		from="${chapters%%,*}"
		to="${chapters##*,}"
	else
		from="$chapters"
		to="$chapters"
	fi
fi

if [[ -n "$from" && -n "$2" ]]; then
	echo "Error: Cannot use both --from and positional argument for FROM_CHAPTER"
	echo "$help_short"
	exit 1
elif [[ -n "$2" ]]; then
	from="$2"
elif [[ -z "$from" ]]; then
	from=1
fi

if [[ -n "$to" && -n "$3" ]]; then
	echo "Error: Cannot use both --to and positional argument for TO_CHAPTER"
	echo "$help_short"
	exit 1
elif [[ -n "$3" ]]; then
	to="$3"
elif [[ -z "$to" ]]; then
	to=9999
fi

{ is_number "$from" && is_number "$to"; } || { echo "Error: FROM_CHAPTER and/or TO_CHAPTER must be integers or decimals. $help_short"; exit 1; }
if (( $(echo "$from > $to" | bc -l) )); then
    echo "Error: FROM_CHAPTER cannot be greater than TO_CHAPTER."
    exit 1
fi

from="$(make_decimal "$from")"
to="$(make_decimal "$to")"

[[ -n "$output_pdf" ]] || output_pdf="$title.pdf"
[[ "$output_pdf" == *.pdf ]] || output_pdf="$output_pdf.pdf"
[[ "$output_pdf" == /* ]] || output_pdf="$output_dir/$output_pdf"

[[ -d "$output_dir" ]] || mkdir -p "$output_dir"

images="$(basename "$output_pdf" .pdf).images"
images_dir="$output_dir/$images"

echo "Title: $title"
echo "From:  $from"
echo -e "To:    $to\n"

echo "Finding host..."
get_new_host "$(get_image_name "$from" 1)" || { echo "Error: No host was found. Try both JP and EN titles of the series and make sure the entered staring chapter exists for the series"; exit 1; }

pages_downloaded=0
chapters_downloaded=0
reset="                                                          "

echo -e "Downloading chapters...\n\n"
for chapter in $(seq "$from" "$step" "$to"); do
	chapter_split="$(split_number "$chapter")"
	chapter_pretty="${chapter_split//;/}"
	page=1

	while :; do
		update_progress "$chapter_pretty" "$page" "$chapters_downloaded" "$pages_downloaded"
		image="$(get_image_name "$chapter" "$page")"

		if [[ ! -f "$images_dir/$image" ]]; then
		    if ! download_image "$image"; then
		        if [[ "$page" -eq 1 ]]; then
		            get_new_host "$image" && download_image "$image" || "$ignore_if_fail" || break
		        else
		            break
		        fi
		    fi
		fi

		((page++))
		((pages_downloaded++))
	done

	[[ "$page" -gt 1 ]] && ((chapters_downloaded++))
	[[ "$chapter" == "$to" ]] && update_progress "$chapter" "$page" "$chapters_downloaded" "$pages_downloaded"
done

img_dl_info="Images are preserved in $images_dir"
echo -e "$reset"

if "$no_pdf"; then
	echo "Images downloaded to $images_dir"
elif img2pdf "$images_dir"/* -o "$output_pdf"; then
	echo "PDF created: $output_pdf"
	{ "$keep_images" && echo "$img_dl_info"; } || rm -rf "$images_dir"
else
	echo -e "Error: Failed to create PDF.\n$img_dl_info"
	exit 1
fi
