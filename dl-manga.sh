#!/bin/bash -e

BASEURL=$1

COOKIEJAR=$(mktemp -t cookiejar)
BINWGET="wget --quiet --load-cookies $COOKIEJAR --save-cookies $COOKIEJAR"


function DLCHAPTER {
    CHAPTERURL=$1
    SITETMP=$(mktemp -t sitetmp)

    ${BINWGET} -O $SITETMP $CHAPTERURL

    CHAPTERNAME=$(xmllint --html -xpath "string(//select[contains(@class, 'navi-change-chapter')]/option[@selected]/text())" $SITETMP | sed 's/\W/_/g')
    PANELURLS=$(xmllint --html -xpath "//div[contains(@class, 'container-chapter-reader')]/img/@src" $SITETMP | tr " " "\n" | awk -F '"' '{print $2}')
    FILENAME=$(xmllint --html -xpath "string(//div[contains(@class, 'info-top-chapter')]/h2/text() | //div[contains(@class, 'panel-chapter-info-top')]/h1/text())" $SITETMP | sed 's/\W/_/g')
    FILENAMECBZ=$FILENAME.cbz
    
    for PANELURL in $PANELURLS
    do
        #echo "$CHAPTERNAME - ${PANELURL##*/}"
        PANELNAME="$CHAPTERNAME - ${PANELURL##*/}" 
        
        ${BINWGET} --referer=$CHAPTERURL -O "$PANELNAME" "$PANELURL"
        
        zip -rq "$FILENAMECBZ" "$PANELNAME"
        rm "$PANELNAME"
    done
    

    # return next chapter url 
    echo $(xmllint --html -xpath "string(//div[contains(@class, 'btn-navigation-chap')]/a[contains(@class, 'back')]/@href | //a[contains(@class,'navi-change-chapter-btn-next')]/@href)" $SITETMP )
}


time while [ -n "$BASEURL" ]
do
    BASEURL=$(DLCHAPTER $BASEURL)
done 