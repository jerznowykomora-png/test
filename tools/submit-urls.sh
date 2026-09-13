#!/usr/bin/env bash
# =============================================================================
#  submit-urls.sh — przyspieszenie odkrycia /indeksacji nowych URL-i
#  striptokens.live · 2026-09-13
#
#  Użycie:
#     chmod +x tools/submit-urls.sh
#     ./tools/submit-urls.sh                       # wyśle wszystkie nowe URL-e
#     ./tools/submit-urls.sh https://striptokens.live/stripchat-hack/
#
#  UWAGA: Google od 2023 r. nie obsługuje już pingowania sitemap przez
#  google.com/ping. Dla Google jedyną oficjalną drogą jest Google Search
#  Console (Inspekcja URL → Poproś o indeksowanie) albo API GSC.
#  Ten skrypt wysyła zgłoszenia do Binga (ping + IndexNow), co i tak pomaga,
#  bo Bing często indeksuje szybciej, a Google obserwuje świeże URL-e.
# =============================================================================

set -euo pipefail

DOMAIN="striptokens.live"
SITEMAP="https://${DOMAIN}/sitemap.xml"
# Klucz IndexNow — musi być dostępny jako plik tekstowy w katalogu głównym:
#   https://striptokens.live/<KEY>.txt   (zawartość: ten sam ciąg znaków)
INDEXNOW_KEY="${INDEXNOW_KEY:-}"

# Domyślna lista = nowe / ostatnio zmienione strony
URLS=("$@")
if [ ${#URLS[@]} -eq 0 ]; then
  URLS=(
    "https://${DOMAIN}/stripchat-hack/"
    "https://${DOMAIN}/stripchat-tokens-generator/"
    "https://${DOMAIN}/blog/stripchat-mod-apk-danger/"
    "https://${DOMAIN}/"
  )
fi

echo "==> 1/3 Ping do Bing (sitemap)"
curl -sS -o /dev/null -w "    HTTP %{http_code}\n" \
  "https://www.bing.com/ping?sitemap=${SITEMAP}" || true

echo "==> 2/3 IndexNow (Bing, Yandex, Seznam, Naver)"
if [ -z "${INDEXNOW_KEY}" ]; then
  echo "    POMINIĘTO — ustaw zmienną INDEXNOW_KEY i wrzuć plik"
  echo "    https://${DOMAIN}/<KEY>.txt na serwer, żeby to działało."
  echo "    (Panel Bing Webmaster Tools → IndexNow → wygeneruj klucz)"
else
  # Budujemy JSON ręcznie, żeby nie wymagać jq
  JSON="{\"host\":\"${DOMAIN}\",\"key\":\"${INDEXNOW_KEY}\",\"keyLocation\":\"https://${DOMAIN}/${INDEXNOW_KEY}.txt\",\"urlList\":["
  for i in "${!URLS[@]}"; do
    [ "$i" -gt 0 ] && JSON+=","
    JSON+="\"${URLS[$i]}\""
  done
  JSON+="]}"

  curl -sS -X POST "https://api.indexnow.org/indexnow" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d "${JSON}" -w "\n    HTTP %{http_code}\n" || true
fi

echo "==> 3/3 Google — zrób to ręcznie (jedyna skuteczna droga):"
for u in "${URLS[@]}"; do
  echo "    GSC → Inspekcja adresu URL → wklej: ${u}"
  echo "         → 'Testuj live URL' → 'Poproś o indeksowanie'"
done

echo
echo "==> Sprawdź też, czy serwer NIE wysyła nagłówka blokującego:"
echo "    curl -sSI https://${DOMAIN}/stripchat-hack/ | grep -i -E 'x-robots-tag|http/'"
echo "    (jeśli zobaczysz 'X-Robots-Tag: noindex' — to jest przyczyna nr 1;"
echo "     szukaj tego nagłówka w konfiguracji LiteSpeed/.htaccess/wtyczce)"
echo
echo "Gotowe. Google zazwyczaj potrzebuje 3–14 dni od zgłoszenia."
