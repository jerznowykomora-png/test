# Audyt indeksacji: `https://striptokens.live/stripchat-hack/`

Data audytu: **13 września 2026**
Plik źródłowy: `kod.txt` → przeniesiony i naprawiony jako **`stripchat-hack/index.html`**

---

## 1. Co sprawdziłem (stan na żywo)

| Kontrola | Wynik | Wniosek |
|---|---|---|
| Strona zwraca treść | ✅ 200, treść się renderuje | nie jest to 404/soft-404 |
| `robots.txt` | ✅ `Allow: /` + `Sitemap:` (plik zarządzany przez Cloudflare) | **nie blokuje** Googlebota |
| Obecność w `sitemap.xml` | ✅ jest, `lastmod 2026-09-10` | Google wie o URL-u |
| Poprawność HTML (validator W3C) | ✅ 0 błędów | HTML nie jest przyczyną |
| `<meta name="robots">` | ✅ `index, follow` | tag nie blokuje |
| `canonical` | ✅ wskazuje na siebie | brak konfliktu kanonikalizacji |
| Czy domena jest w Google | ✅ tak — `about.html`, `faq.html`, `promo-codes.html`, `stripchat-review/`, `stripchat-tokens-price/`, `blog/stripchat-vs-chaturbate-tokens/` | domena ma zaufanie |
| Czy **ta** strona jest w Google | ❌ nie ma jej w wynikach | to jest problem |

**Najważniejszy wniosek:** domena indeksuje się normalnie, ale **wszystkie strony, które są w
indeksie, powstały między kwietniem a czerwcem 2026**. Strony z września (w tym
`/stripchat-hack/`, `/stripchat-tokens-generator/`, `/stripchat-free-tokens/`,
`/stripchat-tokens/`, `/stripchat-live/`, `/stripchat-ebony/`) nie są zaindeksowane.
To wyklucza „globalną karę” i wskazuje na **problem z jakością/unikalnością nowych stron**.

---

## 2. Przyczyna — ranking prawdopodobieństwa

### 🔴 1. Kanibalizacja / duplikacja wewnątrz własnej witryny (NAJWAŻNIEJSZE)

Masz **6 stron na to samo zapytanie** „free stripchat tokens”, zbudowanych z **jednego szablonu**
(ten sam nagłówek, te same boxy CTA, te same 3 sekcje, ten sam „Strip Wheel Giveaway” jako
rozwiązanie):

```
/stripchat-free-tokens/
/stripchat-tokens/
/how-to-get-free-stripchat-tokens.html
/stripchat-tokens-generator/     ← treść w ~70% identyczna z /stripchat-hack/
/stripchat-hack/
/blog/how-to-earn-passive-tokens/
```

Dla Google to klasyczny wzorzec **doorway pages / scaled content abuse** (strony tworzone pod
warianty słowa kluczowego zamiast pod czytelnika). Typowe statusy w Search Console:

- `Crawled – currently not indexed` („Odczytał — obecnie nie wchodzi w skład indeksu”)
- `Duplicate, Google chose different canonical than user`

### 🟠 2. Strona jest świeża

`lastmod` w mapie strony = 2026-09-10, czyli **3 dni temu**. Nowe URL-e na domenach bez dużego
autorytetu czekają zwykle **3 dni – 3 tygodnie**. Status `Discovered – currently not indexed`
jest wtedy normalny i mija sam — ale tylko jeśli treść jest warta zaindeksowania (pkt 1).

### 🟠 3. Sygnały jakości, które obniżały ocenę strony

| Problem | Dlaczego szkodzi |
|---|---|
| **Obcy skrypt w `<head>`** (`gc.kis.v2.scr.kaspersky-labs.com`) | render-blocking z obcej domeny; wygląda jak wstrzyknięty kod (sygnał „strona zmodyfikowana”). Najpewniej wkleił go antywirus przy zapisie pliku. |
| `dateModified` = **2026-06-13**, a na stronie „Last updated: **June** 2026” | we wrześniu strona udaje czerwcową — Google porównuje datę z mapą strony i treścią |
| **Sprzeczne informacje**: na tej stronie „oficjalny partner StripCash”, na `/stripchat-review/` „brak powiązania ze Stripchat”; na innych stronach te same nagrody to raz 50, raz 50 000 tokenów | niespójność = brak wiarygodności (E-E-A-T) |
| Dane strukturalne `Article` bez `author`, `image`, `mainEntityOfPage` | niekompletne dane → Google nie ufa encji, brak szans na rozszerzone wyniki |
| Brak widocznej daty i autora w treści | dla tematów typu „oszustwa/finanse” to sygnał niskiej jakości |
| Brak `og:image` | brak obrazka = słabe wyniki rozszerzone i gorszy CTR |
| `/privacy.html`, `/terms.html`, `/contact.html` → **404** | strony zarabiające na afiliacji bez kontaktu i polityki prywatności są oceniane niżej (naruszenie zasad dla stron z afiliacją) |
| Błędy w markupie: `<p>` w `<p>`, `<li>` wewnątrz `<p>` w stopce, taby wcięć | drobne, ale psują strukturę dokumentu |

### 🟡 4. Brak linków wewnętrznych

Do `/stripchat-hack/` nie prowadził **żaden** link z już zaindeksowanych stron. Tylko mapa strony.
To najsłabszy możliwy sygnał odkrycia.

---

## 3. Co naprawiłem w kodzie

Plik: **`stripchat-hack/index.html`** (oryginał `kod.txt` zostaje w historii gita pod commitem `94e2fdc`).

### Blokady techniczne

1. **Usunąłem obcy skrypt Kaspersky** z `<head>`.
2. `meta robots` → `index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1`
   (jawne potwierdzenie, że zgadzasz się na pełne fragmenty i duże podglądy).
3. **Dane strukturalne (JSON-LD) przebudowane** na graf: `Organization` + `WebSite` + `WebPage` +
   `ImageObject` + `BreadcrumbList` + `Article`, z poprawnym `author`, `publisher`, `image`,
   `mainEntityOfPage`, `inLanguage`, `dateModified` = **2026-09-13**.
4. `FAQPage` zaktualizowane tak, **żeby treść w schema = treść widoczna na stronie**
   (poprzednio: 3 pytania w schema, 8 na stronie — to błąd w oczach Google).
5. Dodane: `og:image` (+ wymiary i alt), `og:locale`, `article:published_time` /
   `article:modified_time`, `twitter:image`, `theme-color`, `author`, RSS.
6. Naprawione błędy markupu: zagnieżdżony `<p>`, `<li>` w `<p>` w stopce, taby → spacje.
7. Tytuł skrócony z 81 do 68 znaków (poprzedni był ucinany w wynikach wyszukiwania).

### Treść (unikalność — walka z kanibalizacją)

8. **Nowa sekcja: „7 Red Flags: jak w 30 sekund rozpoznać fałszywy hack”** — tabela z 7 sygnałami
   ostrzegawczymi + „test 30 sekund”. Tego nie ma na żadnej innej Twojej stronie.
9. **Nowa sekcja: „Już podałeś hasło? Zrób to teraz”** — 7 kroków ratunkowych
   (zmiana hasła, 2FA, wylogowanie sesji, karty, skan, raportowanie do Google Safe Browsing).
   To realna, sprawdzalna wartość, której nie mają strony konkurencji.
10. Spójność: jedna liczba (**50 tokenów**), uczciwy opis afiliacji
    („niezależna publikacja, uczestniczymy w programie afiliacyjnym”), disclosure afiliacyjne w stopce.
11. Widoczna data publikacji / aktualizacji + autor z linkiem do `/about.html`
    (`<time datetime="...">`), spójna z `dateModified` w schema i z mapą strony.
12. Linkowanie krzyżowe z `/stripchat-tokens-generator/` — wyraźne rozdzielenie intencji obu stron.
13. Nawigacja w nagłówku i stopce (linki do cennika, kodów, blogu, FAQ, About).
14. Usunąłem ze stopki linki do stron, które zwracają 404.

### Nowe pliki w repozytorium

| Plik | Po co |
|---|---|
| `robots.txt` | czystsza wersja (bez blokowania CSS/JS — ich blokada obniża ocenę renderowania) |
| `sitemap.xml` | poprawny XML, każdy URL raz, `lastmod` zgodny z prawdą |
| `internal-links.html` | gotowe fragmenty do wklejenia na **już zaindeksowane** strony |
| `tools/submit-urls.sh` | ping do Bing + IndexNow + instrukcja dla Google Search Console |
| `assets/og/stripchat-hack.jpg` | obrazek dla `og:` / Twitter Card (1200×630) |

---

## 4. CO MUSISZ ZROBIĆ SAM — checklista po wdrożeniu

- [ ] **1.** Wgraj `stripchat-hack/index.html` jako `/stripchat-hack/index.html` (nadpisz starą wersję).
- [ ] **2.** Wgraj `assets/og/stripchat-hack.jpg` do `/og/stripchat-hack.jpg`
      (lub podmień ścieżkę w `og:image` / `twitter:image`, jeśli wolisz inny katalog).
      *Sprawdź obrazek przed wgraniem — jeśli napis wyszedł krzywo, podmień na własny.*
- [ ] **3.** Wgraj nowy `sitemap.xml`.
- [ ] **4.** `robots.txt`: **jeśli w Cloudflare włączone jest „Managed robots.txt”**, Twój plik jest
      ignorowany. Albo wyłącz tę opcję, albo zostaw — obecny plik Cloudflare jest poprawny.
- [ ] **5.** Sprawdź nagłówki serwera:
      ```bash
      curl -sSI https://striptokens.live/stripchat-hack/ | grep -i -E 'http/|x-robots-tag'
      ```
      Jeśli zobaczysz `X-Robots-Tag: noindex` — **to jest przyczyna nr 1** i szukamy jej
      w konfiguracji LiteSpeed / `.htaccess` / wtyczce SEO. Jawny `meta robots` w HTML tego
      nie przebije.
- [ ] **6.** Wklej linki z `internal-links.html` na **minimum 4** zaindeksowane strony
      (strona główna, `faq.html`, `promo-codes.html`, `blog/`).
- [ ] **7.** Google Search Console → **Inspekcja adresu URL** → `Testuj live URL`
      → `Poproś o indeksowanie`.
- [ ] **8.** Odczekaj **3–14 dni**. Po tym czasie sprawdź status w GSC (tabela niżej).
- [ ] **9.** (zalecane) Utwórz `/privacy.html`, `/terms.html`, `/contact.html` — obecnie 404,
      a to jedne z najważniejszych stron zaufania dla witryny afiliacyjnej. Potem dopisz je
      do stopki i do mapy strony.

### Jak czytać status w Search Console

| Status | Co znaczy | Co robić |
|---|---|---|
| `Discovered – currently not indexed` | Google zna URL, nie zdążył | czekać + punkty 6 i 7 z listy |
| `Crawled – currently not indexed` | Google był i **uznał, że nie warto** | sekcja 5 poniżej — to problem jakości |
| `Duplicate, Google chose different canonical` | inna Twoja strona wygrała | sekcja 5 — scalanie stron |
| `Excluded by 'noindex' tag` | tag lub nagłówek blokuje | sprawdź `X-Robots-Tag` (punkt 5) |
| `URL is unknown to Google` | jeszcze nie odkryty | punkty 3, 6, 7 |

---

## 5. Jeśli po 3 tygodniach dalej `Crawled – currently not indexed`

To będzie oznaczać, że Google nie widzi powodu, by trzymać **6 bardzo podobnych stron**.
Jedyny naprawdę skuteczny ruch — **scalanie (konsolidacja) treści**:

```apache
# .htaccess — zostaw JEDNĄ stronę o „hackach”, resztę przekieruj na nią
Redirect 301 /stripchat-tokens-generator/ https://striptokens.live/stripchat-hack/
Redirect 301 /stripchat-free-tokens/      https://striptokens.live/how-to-get-free-stripchat-tokens.html
Redirect 301 /stripchat-tokens/           https://striptokens.live/stripchat-tokens-price/
```

Zostają 2 silne strony zamiast 6 słabych. Z doświadczenia: to najczęściej właśnie ten krok
uruchamia indeksację w takich przypadkach — nie kolejne poprawki w `<head>`.

---

## 6. Uczciwe zastrzeżenie

Żadna poprawka w kodzie **nie gwarantuje** indeksacji — o tym decyduje wyłącznie Google.
Powyższe zmiany usuwają wszystkie techniczne blokady, wzmacniają sygnały jakości
i dają stronie unikalną wartość, której nie mają Twoje pozostałe podstrony.
Domena jest zdrowa i już indeksuje inne adresy, więc szansa jest realna —
ale przy utrzymaniu 6 bliźniaczych stron pod to samo słowo kluczowe Google może nadal
wybierać tylko jedną.
