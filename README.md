# dl-manga
primitive manga downloaded for https://manganato.com/ to cbz

## download once
`docker run --rm -ti -v "$(pwd)/manga":/manga vonproteus/dl-manga dl-manga.sh https://readmanganato.com/manga-dr980474/chapter-178` 

This command will download chapter 178 and each subsequent one. After that it will compress each chapter into a separate cbz.

Downloaded fils will be in `$(pwd)/manga`

## download ongoing series 

### add new series

`docker run --rm -ti -v "$(pwd)/manga":/manga -v "$(pwd)/config":/config vonproteus/dl-manga dl-add.sh https://readmanganato.com/manga-dr980474/chapter-178 "./Solo Leveling"`

This command will download all chapters starting with 178 to `$(pwd)/manga/Solo Leveling` and add to config this manga. Config is saved in `$(pwd)/config/config.xml` you can add multiple manga to config one after another

### download from config

`docker run --rm -ti -v "$(pwd)/manga":/manga -v "$(pwd)/config":/config vonproteus/dl-manga`

This command checks for new chapters of mangas in config file, if found, it will download them 

## environment variables

`CONFIG_FILE` location of the configuration file default: `/config/config.xml`

`NO_CBZ` if set downloaded panels won't be compressed to cbz