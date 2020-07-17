#!/bin/bash

ORGANISM="dm6"
RAWDATA="dmel"

CHROMOSOMES="2R 2L 3R 3L X"
POPTEST="pi theta fst"
# POPTEST="pi theta"

declare -A COLORS=( ["pi"]="#040486" ["theta"]="#040486" ["fst"]="#6565FB" ["recomb"]="#953364")
declare -A METAPOP=( ["RAL"]="AM" ["ZI"]="AFR" )

COLLAPSETRACKS="\n[trackSelector]\ncollapsedCategories="
DEFAULTTRACKS="\n[GENERAL]\ndefaultTracks=reference_sequence,"
###############################################
###############   HTMLCONFIG   ################
###############################################

if [ ! -e $JBROWSE_DATA/${ORGANISM}/raw/dmel ]; then
    # ln -s ${DATA_DIR}/${RAWDATA}/ $JBROWSE_DATA/${ORGANISM}/raw/dmel;
    # ln -s ${DATA_DIR}/${RAWDATA}/ $JBROWSE_DATA/${ORGANISM}/raw/tracks;
    mkdir -p $JBROWSE_DATA/${ORGANISM}/raw/
    ln -s ${DATA_DIR}/${RAWDATA}/ $JBROWSE/files;
fi;
ln -sf ${DATA_DIR}/dmel.json $JBROWSE_DATA/${ORGANISM}/raw/;
rm $JBROWSE/index.html && ln -s ${DATA_DIR}/index.html $JBROWSE/;
cp -s ${DATA_DIR}/customImages/* $JBROWSE/img/;

###############################################
###############  LOAD SEQ/ANNOTATIONS   ################
###############################################
# Reference sequenes
for NCHR in ${CHROMOSOMES}
do
    prepare-refseqs.pl --fasta ${DATA_DIR}/${RAWDATA}/refseq/Chr${NCHR}.fasta --out ${JBROWSE_DATA}/${ORGANISM} --key "reference_sequence" --trackLabel "reference_sequence" --trackConfig '{ "category": "ref_tracks"}'
done

biodb-to-json.pl -v --conf ${DATA_DIR}/dmel.json --out $JBROWSE_DATA/${ORGANISM};

for ANN in `ls ${DATA_DIR}/dmel/annotations/`
do
    echo ${ANN}
    LABEL=$(echo ${ANN} | cut -d'.' -f1)
    DEFAULTTRACKS="${DEFAULTTRACKS}${LABEL},"

    if [[ ${ANN} =~ 'genes' ]];then
        flatfile-to-json.pl --trackType CanvasFeatures --trackLabel ${LABEL} --autocomplete all --gff  ${DATA_DIR}/dmel/annotations/${ANN} --key $LABEL --config '{ "category": "ref_tracks", "menuTemplate" : [{"iconClass" : "dijitIconTask","action" : "contentDialog","title" : "{type} {name}","label" : "View details"},{"iconClass" : "dijitIconFilter"},{"label" : "Search gene on NCBI","title" : "Search on NCBI {name}","iconClass" : "dijitIconDatabase","action": "newWindow","url" : "https://www.ncbi.nlm.nih.gov/gquery/?term={id}"},{"label" : "Search gene on flybase","title" : "Search on flybase {name}","iconClass" : "dijitIconFile","action": "newWindow","url" : "http://flybase.org/reports/{id}"}]}' --metadata '{"general_tracks":"Gene annotations"}' \
        --out ${JBROWSE_DATA}/${ORGANISM}/
    else
        echo $ANN
        flatfile-to-json.pl --className "feature2" --arrowheadClass "null" --trackLabel ${LABEL} --autocomplete all --gff ${DATA_DIR}/dmel/annotations/${ANN} --key $LABEL --config '{ "category": "ref_tracks"}' --metadata '{"general_tracks":"annotations"}' \
        --out ${JBROWSE_DATA}/${ORGANISM}/
    fi
done

###############################################
###############  LOAD BY POP   ################
###############################################
for TEST in ${POPTEST}
do

    DESCRIPTION=$(fgrep $TEST ${DATA_DIR}/description.txt | cut -d'=' -f2)
    echo ${TEST}
    TRACKCOLOR=${COLORS[${TEST}]}

    if [[ ${TEST} == 'fst' ]];then

        SUBCAT="Variation/population_diferentiation"
        COLLAPSETRACKS="${COLLAPSETRACKS}${SUBCAT},"
    else
        SUBCAT='Variation/freq_nucleotide_variation'
        COLLAPSETRACKS="${COLLAPSETRACKS}${SUBCAT},"
    fi

    for TRACK in `ls ${JBROWSE}/files/${TEST}`
    do
        echo ${TRACK}
        POP=$(cut -d'_' -f1 <<< ${TRACK})
        add-bw-track.pl --category "${SUBCAT}" \
                --label "${TRACK}" \
                --key "${TRACK}" \
                --plot \
                --pos_color "${TRACKCOLOR}" \
                --bw_url ../../files/${TEST}/${TRACK} \
                --config '{"metadata":{ "population":'\"${POP}\"',"metapopulation":'\"${METAPOP[${POP}]}\"',"freq_nucleotide_variation":'\"${TEST}\"',"window_size":"10kb","description":'${DESCRIPTION}'}}' \
                --in ${JBROWSE_DATA}/${ORGANISM}/trackList.json \
                --out ${JBROWSE_DATA}/${ORGANISM}/trackList.json
    done
done
###############################################
############### DEFAULT TRACKS ################
###############################################

for TRACK in `ls ${DATA_DIR}/dmel/reftracks`
do
    echo ${TRACK}
    if [[ ${TRACK} =~ 'recomb' || ${TRACK} =~ 'RRC' ]];then
        SUBCAT="Variation/Recombination"
        COLLAPSETRACKS="${COLLAPSETRACKS}${SUBCAT},"
    else
        SUBCAT="ref_tracks"
    fi

    LABEL=$(echo ${TRACK} | cut -d'.' -f1)
    DEFAULTTRACKS="${DEFAULTTRACKS}${LABEL},"
    add-bw-track.pl --category ${SUBCAT} \
                            --label "${LABEL}" \
                            --key "${LABEL}"\
                            --plot \
                            --pos_color "#34A853" \
                            --bw_url ../../files/reftracks/${TRACK} \
                            --in ${JBROWSE_DATA}/${ORGANISM}/trackList.json \
                            --out ${JBROWSE_DATA}/${ORGANISM}/trackList.json
done

###############################################
###############  JBROWSE CONF  ################
###############################################

add-json.pl '{ "dataset_id": "dmel", "include": [ "functions.conf" ] }' $JBROWSE_DATA/${ORGANISM}/trackList.json
cp ${DATA_DIR}/functions.conf $JBROWSE_DATA/${ORGANISM}/functions.conf

printf "\n[general]\ndataset_id = ${ORGANISM}\n" >> ${JBROWSE_DATA}/${ORGANISM}/tracks.conf

printf "\n[datasets.${ORGANISM}]\nurl  = ?data=data/${ORGANISM}\nname = ${ORGANISM}\n" >> $JBROWSE/jbrowse.conf

DEFAULTTRACKS=$(sed 's/.$/\\n/' <<< $DEFAULTTRACKS)
printf ${DEFAULTTRACKS} >> $JBROWSE/jbrowse.conf

COLLAPSETRACKS=$(sed 's/.$/\\n/' <<< $COLLAPSETRACKS)
printf ${COLLAPSETRACKS} >> $JBROWSE/jbrowse.conf

generate-names.pl --safeMode -v --out $JBROWSE_DATA/${ORGANISM};

# nginx -g "daemon off;"