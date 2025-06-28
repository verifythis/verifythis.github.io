# Website of VerifyThis (ETAPS and Long-Term Challenge)

This repo hosts the web pages for both verifythis onsite and ltc events. The page is available under
https://verifythis.github.io/

The webpage has been designed and implemented by Alexander Weigl (@wadoon on github).
@mattulbrich can also be asked for most questions.

This page uses [Hugo](https://gohugo.io/) to compose static pages from input descriptions.
It relies on [SASS](https://sass-lang.com/) for preprocessing of style sheets.

The github workflow in `.github/workflows/hugo.yml` compiles the pages on checkin 

In order to test the page, you can do one of the following (after initialising docker, s. below)

1. Run the shell script `./produce.sh` to compile the site once to the directory "out".
2. Run the shell script `./produce.sh server` to watch the directry and to compile the site continuously whenever a change in the sources appeards. With the server you can launch a browser on http://localhost:1313 to check the site locally.

For either option, you need to first generate a docker image using `docker build verifythis-www .` in the repo directory.

## Editing

### Pages

Pages are written in markdown, but can theoretically also be written in html.
Hugo escapes can be embedded.
* `content` hosts the main page
* `content/onsite` has the competition sub page.
* `content/ltc` has the ltc sub page.

### How to add a news item?

For the ltc:
- Add a file to `content/ltc/news`.
- Fill out the header lines:
 - Just copy them from another file.
 - Set the title, your name, and the date when the news should be live
 - Use `<!-- more -->` to indicate where the preview should end.
 
For the onsite: I assume it will be the same ;)

### How to add another competition?

To add another iteration of the etaps WS: Just copy the last one and adapt the files in an obvious fashion. It will automatically show up in the listing

## TODO 
* [x] Scraping/replicate the current ETHZ site
      incl. all submitted artifacts
* [x] Merge with VT LTC
* [x] Clean up site structure for VT LTC
* [x] Landing page for VT onsite
* [ ] Landing page for VerifyThis Overall
* [ ] Design
  * [ ] Test for small devices
* [ ] Link checking
* [x] Prepare 2025
  * [x] Archive 2024
    * [x] Created. Challenges archived 
    * [ ] Solutions are missing. 
  * [ ] Update "Call for Problems"
  * [ ] Update "Call for Participation"

